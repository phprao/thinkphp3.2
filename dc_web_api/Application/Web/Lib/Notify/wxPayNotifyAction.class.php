<?php

namespace Web\Lib\Notify;

require(APP_PATH . 'Web/Lib/wxpay_gzh_ext/lib/WxPay.Api.php');
require(APP_PATH . 'Web/Lib/wxpay_gzh_ext/lib/WxPay.Notify.php');

use Web\Lib\Redis\PlayerRedis;

class wxPayNotifyAction extends \WxPayNotify{
	protected $change_money_type_money = 10; // 余额

	//查询订单
	public function Queryorder($transaction_id)
	{
		$input = new \WxPayOrderQuery();
		$input->SetTransaction_id($transaction_id);
		$result = \WxPayApi::orderQuery($input);
		if(array_key_exists("return_code", $result)
			&& array_key_exists("result_code", $result)
			&& $result["return_code"] == "SUCCESS"
			&& $result["result_code"] == "SUCCESS")
		{
			return true;
		}
		return false;
	}

	public function NotifyProcess($data, &$msg){
		
		if(!array_key_exists("transaction_id", $data)){
			$msg = "输入参数不正确";
			return false;
		}

		//查询订单，判断订单真实性
		if(!$this->Queryorder($data["transaction_id"])){
			$msg = "订单查询失败";
			return false;
		}

		// 订单状态
		if($data['return_code'] != 'SUCCESS' || $data['result_code'] != 'SUCCESS'){
			$msg = "订单支付失败";
			return false;
		}

		$this->responseData = $data;

        // 业务实现
        if(!$this->orderAction()){
        	\Think\Log::write('订单信息处理失败，请检查原因。orderno:'.$this->responseData['out_trade_no'],'INFO');
        	$msg = "业务处理失败";
			return false;
        }else{
        	\Think\Log::write('订单信息处理完成。orderno:'.$this->responseData['out_trade_no'],'INFO');
        	$msg = "业务处理成功";
			return true;
        }

	}

	// 实现业务逻辑
	public function orderAction(){

		$returnParam = $this->responseData;
		$this->orders = M('order_log')->where(['order_orderno'=>$returnParam['out_trade_no']])->find();
		if(empty($this->orders)){
			\Think\Log::write('该订单不存在 orderno:'.$returnParam['out_trade_no'],'WARN');
			return false;
		}
		if($this->orders['order_is_send'] == 1){
			return true;
		}
		if($this->orders['order_price'] != $returnParam['total_fee']){
			\Think\Log::write('该订单价格不匹配 orderno:'.$returnParam['out_trade_no'].' '.$this->orders['order_price'].'/'.$returnParam['total_fee'],'WARN');
			return false;
		}

		// appId
		if($returnParam['appid'] != C('APPID')){
			\Think\Log::write('appid校验失败 orderno:'.$returnParam['out_trade_no'].' '.$returnParam['appid'].'/'.C('APPID'),'WARN');
			return false;
		}

		// mch_id
		if($returnParam['mch_id'] != C('MCHID')){
			\Think\Log::write('mch_id校验失败 orderno:'.$returnParam['out_trade_no'].' '.$returnParam['mch_id'].'/'.C('MCHID'),'WARN');
			return false;
		}

		if($this->orders['order_pay_channel'] != 6){
			\Think\Log::write('该订单不是通过微信支付的 orderno:'.$returnParam['out_trade_no'],'WARN');
			return false;
		}

		if($this->orders['order_goods_id'] > 0){
			$goodsinfo = M('goods_info')->where(['goods_id'=>$this->orders['order_goods_id']])->find();
			// 商品信息
			if(empty($goodsinfo)){
			   \Think\Log::write("商品信息有误 orderno:".$returnParam['out_trade_no'],'WARN');
			   return false;	 
			}
		}
		
		// 业务处理
		$playerId = $this->orders['order_player_id'];

		// 业务分支
		M()->startTrans();		
		
		$re1 = $this->recharge();

		//付款记录
	    $re3 = M('pay_record')->add([
			'recore_player_id'    =>$playerId,
			'recore_club_id'      =>$this->orders['order_club_id'],
			'recore_type'         =>5,// 为公众号支付
			'recore_price'        =>$this->orders['order_price'],
			'recore_get_price'    =>$this->orders['order_get_price'],
			'recore_get_type'     =>$this->orders['order_get_type'],
			'recore_before_money' =>$this->before_value,
			'recore_order_id'     =>$this->orders['order_id'],
			'recore_after_money'  =>$this->after_value,
			'recore_create_time'  =>time()
	    ]);
	    
	    if($this->orders['order_club_card_type'] == 1){
	    	// 更新订单状态
			$re2 = M('order_log')->where('order_id='.$this->orders['order_id'])->save(["order_is_send"=>1,'order_out_transaction_id'=>$returnParam['transaction_id'],'order_update_time'=>time(),'order_sync_status'=>2]);
			// 通用记录
	    	$re4 = M('change_money_info')->add([
				'change_money_player_id'      =>$playerId,
				'change_money_player_club_id' =>$this->orders['order_club_id'],
				'change_money_club_id'        =>$this->orders['order_club_id'],
				'change_money_type'           =>10,
				'change_money_money_type'     =>2,
				'change_money_money_value'    =>$this->orders['order_get_price'],
				'change_money_begin_value'    =>$this->before_value,
				'change_money_after_value'    =>$this->after_value,
				'change_money_time'           =>time()
		    ]);
	    }elseif($this->orders['order_club_card_type'] == 2){
	    	// 更新订单状态
			$re2 = M('order_log')
			      ->where('order_id='.$this->orders['order_id'])
			      ->save([
							"order_is_send"            =>1,
							'order_out_transaction_id' =>$returnParam['transaction_id'],
							'order_update_time'        =>time(),
							'order_sync_status'        =>1,
							'order_sync_task_id'       =>$this->task_id
			      		]);
	    	$re4 = true;
	    }else{
	    	$re2 = false;
	    	$re4 = false;
	    }
	    
		// 后续处理
		if($re1 && $re2 && $re3 && $re4){
			M()->commit();
			\Think\Log::write('微信回调处理完成','INFO');
			return true;
		}else{
		    \Think\Log::write('微信回调处理失败','WARN');
		    M()->rollback();
		   	\Think\Log::write('微信回调处理失败，数据已回滚','WARN');
			return false;
		}

	}

    public function recharge(){
		if($this->orders['order_club_card_type'] == 1){
			// 电子卡
			$redis = new \Web\Lib\Redis\PlayerRedis(['table' => 'club_user', 'club_id'=>$this->orders['order_club_id']]);
            $exists = $redis->exists($this->orders['order_player_id']);
            if($exists){
            	$data = $redis->hgetall($this->orders['order_player_id']);
            	$before_coin = $data['player_amount'];
            	$result      = $redis->hincrby($this->orders['order_player_id'], 'player_amount', $this->orders['order_get_price']);
            	$after_coin  = $before_coin + $this->orders['order_get_price'];
            }else{
            	$before_coin = M('club_player')->where(['player_id'=>$this->orders['order_player_id']])->getField('player_amount');
				$result      = M('club_player')->where(['player_id'=>$this->orders['order_player_id']])->setInc('player_amount', $this->orders['order_get_price']);
				$after_coin  = $before_coin + $this->orders['order_get_price'];
            }
			
			if($result !== false){
				$this->before_value = $before_coin;
				$this->after_value  = $after_coin;
				return true;
			}else{
				$this->before_value = 0;
				$this->after_value  = 0;
				return false;
			}
		}elseif($this->orders['order_club_card_type'] == 2){
			$club_card = M('club_card')
			              ->where([
									'club_card_status'    =>2, 
									'club_card_id'        =>$this->orders['order_club_card_value'],
									'club_card_player_id' =>$this->orders['order_player_id'],
									'club_card_club_id'   =>$this->orders['order_club_id']
				              	])->find();
			// 实体卡充值余额
			$http = new \Web\Lib\Service\HttpService();
	        $data = [
                'action'     => 'uxuncointransfer',
                'version'    => 'v10001',
                'key_value'  => 1,
                'flag_value' => 1,
                'sign_value' => time(),
                'data_value' =>
                    [
						'app_id'		  =>$club_card['club_card_app_id'],
						'club_id'         =>$this->orders['order_club_id'],
						'player_id'       =>$this->orders['order_player_id'], 
						'card_id'         =>$this->orders['order_club_card_value'],
						'task_pay_type'   =>2,// 余额
						'task_out_type'	  =>2,// 余额
						'task_pay_points' =>0,
						'task_out_points' =>$this->orders['order_get_price'],
						'transfer_type'   =>1, // 1为电子卡转优讯卡
						'order_type'      =>1, // 标识是充值业务
						'player_token'    =>'SFNtQW9meEhxZVVZbTYwa3hRNHg0RVVwbVhVUHZaZkpqQT09'
                    ]
            ];
	        $return = $http->get(C('PLAYER_CARD_CHANGE_MONEY') . json_encode($data));
	        // \Think\Log::write('[ uxuncointransfer ]'.$return,'INFO');
	        $result = json_decode($return, true);
	        if(!empty($result) && $result['data_value']['code_value'] == 0 && $result['data_value']['data']['error'] == 0){
				$this->before_value = 0;
				$this->after_value  = 0;
				$this->task_id = $result['data_value']['data']['order_id'];
				return true;
			}else{
				$this->before_value = 0;
				$this->after_value  = 0;
				$this->task_id = '';
				\Think\Log::write('[ wxpay uxuncointransfer error ]'.$return,'INFO');
				return true; // 暂标记为已付款，防止付款信息遗失
			}
		}

		return false;
		
    }


}	