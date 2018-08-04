<?php

namespace Web\Controller;

class ServerController extends BaseController {

	/**
	 * 余额充值回调处理
	 * @return [type] [description]
	 */
	public function wxPayNotifyAction(){
		$Model = new \Web\Lib\Notify\wxPayNotifyAction();
		$Model->Handle(false);
	}

	/*
		<xml><appid><![CDATA[wxddcaf14777d63e4b]]></appid>
		<attach><![CDATA[nothing]]></attach>
		<bank_type><![CDATA[CFT]]></bank_type>
		<cash_fee><![CDATA[1000]]></cash_fee>
		<fee_type><![CDATA[CNY]]></fee_type>
		<is_subscribe><![CDATA[Y]]></is_subscribe>
		<mch_id><![CDATA[1486194142]]></mch_id>
		<nonce_str><![CDATA[m988qu4v7lpx7urpwcups7axst42xc9t]]></nonce_str>
		<openid><![CDATA[otltU1WmzfTwzclhFm3UGlLJ7UTo]]></openid>
		<out_trade_no><![CDATA[1510543ec8b28f8829cedccb]]></out_trade_no>
		<result_code><![CDATA[SUCCESS]]></result_code>
		<return_code><![CDATA[SUCCESS]]></return_code>
		<sign><![CDATA[79995DB69198D1FC7DCF06FA9A32173F]]></sign>
		<time_end><![CDATA[20171226222659]]></time_end>
		<total_fee>1000</total_fee>
		<trade_type><![CDATA[JSAPI]]></trade_type>
		<transaction_id><![CDATA[4200000027201712262097880585]]></transaction_id>
		</xml>
	*/
}
