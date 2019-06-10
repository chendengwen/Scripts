<?php
namespace app\index\controller;
use think\Db;

class Action extends Init
{
    // 弹出上方图片  TODO
    public function get_pop_act_tip()
    {
        $page=$_GET['page'];
        if($page==1) {
            $info = ['id' => '1', 'url' => 'http://www.duoduotou.com/static/images/indexlog.jpg', 'w' => '750', 'h' => '565'];
            $data = ['info' => $info];
            return ['data' => $data, 'rtn' => 0];
        }

    }

    public function report_page_view(){



    }
    //  获得套餐列表  TODO
    public function get_dish_list(){
        // $_GET 变量用于收集来自 method="get" 的表单中的值
        $day=$_GET['day'];
        $type=$_GET['type'];
        $time=$day." 10:30";
        $list=Db::table('cf_menu')->where(array('meals_type'=>$type,'day'=>$day,'status'=>1))->select();
        if(strtotime($time)<time()){
            $enable=false;
        }else{
            $enable=true;
            $day_next=date('Y-m-d',strtotime('+1 day'));
            $data_menu=Db::table('cf_menu')->where(array('meals_type'=>$type,'day'=>$day_next,'status'=>0))->field('id')->select();
            if(!empty($data_menu)){
                Db::table('cf_menu')
                    ->where(array('meals_type'=>$type,'day'=>$day_next,'status'=>0))
                    ->update(['status' =>1]);
            }
        }

        $data=['list'=>$list,'time'=>date('H:m'),'noshop'=>false,'today'=>date('Y-m-d'),'enable'=>$enable,'enable2'=>$enable,'now_time'=>time()];
        return['rtn'=>0,'data'=>$data];
    }

    //
    public function get_channel_dish_list(){

        $type=$_GET['type'];
        $list=Db::table('cf_menu')->where(array('meals_type'=>$type))->select();

        $data=['list'=>$list];
        return['rtn'=>0,'data'=>$data,'time'=>'18:25','noshop'=>false,'today'=>'2016-06-02','enable'=>false,'enable2'=>false];
    }
    //获取用户地理位置信息 TODO
    public function get_regions(){
        $type=isset($_GET['type'])?$_GET['type']:0;
        if($type=='region') {
            $id=isset($_GET['city_id'])?$_GET['city_id']:0;
            $list=Db::table('cf_region')->where(array('city_id'=>$id))->select();
            foreach($list as $key=>$value){
                $list[$key]['name']=$value['region_name'];
            }
        }elseif($type=='company'){
         //   $list[0] =['id'=>3,'name'=>'小小金融','layer'=>16,'lunch_time'=>'12:00','dinner_time'=>"18:00"];
            $layer=$_GET['layer'];
            $building_id=$_GET['building_id'];

            $list=Db::table('cf_company')->where(array('building_id'=>$building_id,'layer'=>$layer,'status'=>1))->select();
            foreach($list as $key=>$value){
                $list[$key]['name']=$value['company'];
            }
        }
        elseif($type=='building'){
            $id=isset($_GET['region_id'])?$_GET['region_id']:0;
            $list=Db::table('cf_building')->where(array('region_id'=>$id,'build_status'=>1))->select();
            foreach($list as $key=>$value){
                $list[$key]['name']=$value['building_name'];
            }
        }
        $data=['list'=>$list];
        return['rtn'=>0,'data'=>$data];
    }
    //设置用户所在大楼 TODO
    public function set_global_addr(){
       $building=$_POST['building'];
        $region=$_POST['region'];
        cookie('building',$building);
        cookie('region',$region);

        
        return['rtn'=>0,'data'=>$building];
    }
    // 订单中获取菜单信息 TODO
    public function get_dish_info(){
        $did=$_GET['did'];
        $ids='';
        $did_arr=json_decode(base64_decode($did));
        foreach($did_arr as $key=>$value){
            $ids .=$value->id.",";
            $dish_map[$value->id]=$value->num;
            $data=Db::table('cf_menu')->where('did',$value->id)->where('remain_num','LT',$value->num)->value('id');
            if(!empty($data)){
                $data=['msg'=>'购物车有商品数量不足','dish'=>[],'today'=>date('Y-m-d'),'dish_map'=>$dish_map];
                return ['rtn'=>0,'data'=>$data ];
            }
        }
        $ids=rtrim($ids,",");

        $dish=Db::table('cf_menu')->where('did','in',$ids)->where('remain_num','NEQ',0)->field('did,meals_type,id,name,dish_type,day,price,vip_price,images')->select();

        $data=['dish'=>$dish,'today'=>date('Y-m-d'),'dish_map'=>$dish_map];
        return['rtn'=>0,'data'=>$data];
    }
    //订单中获取用户地址信息 TODO
    public function get_addr_info(){
        $uid=Db::table('cf_customer')->where('open_id',cookie('open_id'))->value('id');


        $list=Db::table('cf_cust_address')
            ->alias('a')
            ->join('company c','a.company_id = c.id')
            ->join('building b','c.building_id = b.id')
            ->join('region r','b.region_id = r.id')
            ->field('*,c.layer')
            ->where('u_id',$uid)->select();

       // $list[0]=['id'=>1,'user_name'=>'彭万里','phone'=>'13667433427','phone2'=>'','building_id'=>195,'province_id'=>1,'city_id'=>1,'region_id'=>2,'shop_id'=>5,'province_name'=>'广东省','city_name'=>'深圳市','region_name'=>'福田区','building_name'=>'新浩E都','layer'=>24,'disable_msg'=>"",'build_status'=>0,'lunch_status'=>1,'dinner_status'=>0,'tea_status'=>0,'fruit_status'=>1,'west_status'=>0,'lunch_msg'=>'','dinner_msg'=>'','tea_msg'=>'','fruit_msg'=>'','west_msg'=>'','company_id'=>8631,'get_meal_addr'=>'前台','company_type'=>1,'lunch_time'=>'12:00','dinner_time'=>'18:00','company'=>'小小金融','tea_time'=>'17:30 ~ 18:30'];
        $data=['list'=>$list];
        return['rtn'=>0,'data'=>$data];
    }
    //获取用户交易记录 TODO
    public function get_consume_list(){
        $data=['total_page'=>0];
        return['rtn'=>0,'data'=>$data];
    }
    //添加用户收货地址 TODO
    public  function add_addr(){
        $company=$_POST['company'];
        $company_id=$_POST['company_id'];
        $user_name = $_POST['user_name'];
        $building_id=$_POST['building_id'];
        $region=cookie('region');

        $phone=$_POST['phone'];

        $uid=Db::table('cf_customer')->where('open_id',cookie('open_id'))->value('id');
        if(empty($uid)) {

            Db::startTrans();
            try {
            Db::table('cf_customer')->insert(['region' => $region, 'building' => $building_id, 'open_id' => cookie('open_id'), 'user_name' => $user_name, 'type_id' => 1, 'telephone' => $phone, 'last_login_time' => time(), 'register_time' => time()]);
            $uid = Db::getLastInsID();
                // 提交事务
                Db::commit();

            } catch (\PDOException $e) {
                // 回滚事务
                Db::rollback();
            }
        }
        if($company_id=='-1') {
            $dinner_time=$_POST['dinner_time'];
            $lunch_time = $_POST['lunch_time'];
            $layer=$_POST['layer'];
            Db::table('cf_company')->insert(['building_id' => $building_id, 'layer' => $layer, 'lunch_time' => $lunch_time, 'dinner_time' => $dinner_time, 'company' => $company, 'add_time' => time()]);
            $company_id = Db::getLastInsID();

            Db::table('cf_cust_address')
                ->insert(['user_name' => $user_name, 'phone' => $phone, 'company_id' => $company_id,'u_id'=>$uid]);
        }else{
            Db::table('cf_cust_address')
                ->insert(['user_name' => $user_name,'phone'=>$phone,'company_id'=>$company_id,'u_id'=>$uid]);
        }
        $data=['shop_id'=>5];
        return['rtn'=>0,'data'=>$data];
    }
    //编辑用户收货地址 TODO
    public function edit_addr(){
        $uid=Db::table('cf_customer')->where('open_id',cookie('open_id'))->value('id');

        $company=$_POST['company'];
        $company_id=$_POST['company_id'];
        $user_name = $_POST['user_name'];
        $building_id=$_POST['building_id'];
        $phone=$_POST['phone'];

        if($company_id=='-1') {
            $dinner_time=$_POST['dinner_time'];
            $lunch_time = $_POST['lunch_time'];
            $id=$_POST['id'];
            $layer=$_POST['layer'];

            Db::table('cf_company')->insert(['building_id'=>$building_id,'layer'=>$layer,'lunch_time'=>$lunch_time,'dinner_time'=>$dinner_time,'company'=>$company,'add_time'=>time()]);
            $company_id=Db::getLastInsID();

            Db::table('cf_cust_address')
                ->where('u_id', $uid)
                ->update(['user_name' => $user_name,'phone'=>$phone,'company_id'=>$company_id]);
        }else{
            Db::table('cf_cust_address')
                ->where('u_id', $uid)
                ->update(['user_name' => $user_name,'phone'=>$phone,'company_id'=>$company_id]);
        }
        $data=['shop_id'=>5];
        return['rtn'=>0,'data'=>$data];
    }
    //获取用户优惠券信息 TODO
    public function get_user_coupon(){
        $status=$_GET['status'];
      // $list[0]=['id'=>'471101','name'=>'0.5元现金券','price'=>'50','limit_time_start'=>'2016-05-19','limit_time_end'=>'2016-05-29','rule'=>'[{"type":1,"price":1000}]','remark'=>'0.5元现金券','code'=>'602382bd2c431f2489e38761df17f572','status'=>'0','alipay_id'=>'0','consume_id'=>'0','use_time'=>'0000-00-00 00:00:00','end_time'=>'2016-05-29','get_time'=>'2016-05-19 20:18:41'];

        $time=time();
        $uid=Db::table('cf_customer')->where('open_id',cookie('open_id'))->value('id');
        $list=Db::table('cf_cust_ticket')->where('uid', $uid)->where('status',$status)->where('limit_time_start','ELT',$time)->where('limit_time_end','EGT',$time)->field('id,name,amount price,limit_time_start,limit_time_end,rule,remark,status,get_time,end_time')->order('amount desc')->select();


        $data=['list'=>$list,'today'=>date('Y-m-d'),'page'=>'1','totalPage'=>1];
        return['rtn'=>0,'data'=>$data];
    }
    //用户付款 TODO
    public function do_order_pay(){
        header("Content-Type:text/html;charset=utf-8");
        vendor('Pay.JSAPI');
        $oidstr=base64_decode($_POST['oid']);
        $oid= str_replace("xxjrcfid888",'',$oidstr);
        $type=isset($_POST['type'])?$_POST['type']:null;

        $is_rice=isset($_POST['is_rice'])?$_POST['is_rice']:0;

        $price=Db::table('cf_order')->where(['id' => $oid,'status'=>0])->value('amount');

        $menuinfo=Db::table('cf_order')->where(['id' => $oid,'status'=>0])->value('menuinfo');

        $ids='';
        $did_arr=json_decode($menuinfo);
        foreach($did_arr as $key=>$value){
            $ids .=$value->id.",";
            $dish_map[$value->id]=$value->num;
            $data=Db::table('cf_menu')->where('did',$value->id)->where('remain_num','LT',$value->num)->value('id');
            if(!empty($data)){
                $data=['msg'=>'购物车有商品数量不足'];
                return ['rtn'=>1,'data'=>$data ];
            }
        }
        $ids=rtrim($ids,",");

        $dish=Db::table('cf_menu')->where('did','in',$ids)->where('remain_num',0)->field('did,meals_type,id,name,dish_type,day,price,vip_price,images')->select();
        if(!empty($dish)){
            $data=['msg'=>'购物车有商品已卖完'];
            return ['rtn'=>1,'data'=>$data ];
        }


        $rice=Db::table('cf_menu')->where('did','in',$ids)->where('dish_type',5)->value('id');

            if (empty($rice) && $is_rice==0) {
                $data = ['msg' => '您没有订购米饭,是否需要3元加一份米饭'];
                return ['rtn' => 2, 'data' => $data, 'cm_id' => $_POST['oid']];
            }

        $is_first_order=Db::table('cf_customer')->where('open_id',cookie('open_id'))->value('is_first_order');
        if($is_first_order==0 && $price>1000){
//            $price=$price-900;
        }

        if($type==2) {
            $tools = new \JsApiPay();
            $openId = cookie('open_id');

            $Out_trade_no = date('YHis') . rand(100, 1000);
            $Total_fee = '小小金融';
            $Body = date('Y-m-d') . '有菜有饭';
            $Total_fee = $price;
            $input = new \WxPayUnifiedOrder();

            $input->SetBody($Body);
            $input->SetOut_trade_no($Out_trade_no);
            $input->SetTotal_fee($Total_fee);
            $input->SetNotify_url("http://www.duoduotou.com/index/notify");
            $input->SetTrade_type("JSAPI");
            $input->SetOpenid($openId);

            $order = \WxPayApi::unifiedOrder($input);
            $this->jsApiParameters = $tools->GetJsApiParameters($order);

            $pay_info = ['oid' => $oid, 'status' => 0, 'out_trade_no' => $Out_trade_no, 'create_time' => time(), 'pay_price' => $Total_fee];
            Db::table('cf_pay')->insert($pay_info);


            $data = ['pack' => $this->jsApiParameters, 'id' => $_POST['oid']];
            return ['rtn' => 0, 'data' => $data];
        }
        elseif($type==1){
            $pwd=$_POST['pwd'];
            $pay_pwd=Db::table('cf_customer')->where('open_id',cookie('open_id'))->value('password');
            $cb_balance=Db::table('cf_customer')->where('open_id',cookie('open_id'))->value('cb_balance');

            if($pay_pwd != $pwd){
                $data = [ 'msg' => '支付密码不正确'];
                return ['rtn' => 1, 'data' => $data];
            }
            if($price>$cb_balance){
                $data = [ 'msg' => '余额不足'];
                return ['rtn' => 1, 'data' => $data];
            }

            Db::startTrans();
            try {
                $rand=rand(10000,99999);
                $pay_info = ['oid' => $oid, 'status' => 1, 'out_trade_no' => "fl".date('YmdHms').$rand, 'create_time' => time(),'pay_time'=>time(), 'pay_price' => $price];
                Db::table('cf_pay')->insert($pay_info);


                Db::table('cf_order')
                    ->where( ['id' =>$oid,'status'=>0])
                    ->update(['status' => 1,'paytime'=>time(),'bank_no'=>'fanli','paytime'=>time()]);

                $coupon_id=Db::table('cf_order')->where('id', $oid)->value('coupon_id');

                $mene_info=Db::table('cf_order')->where('id',$oid)->value('menuinfo');




                if($coupon_id!=0){
                    Db::table('cf_cust_ticket')
                        ->where( ['id' =>$coupon_id])
                        ->update(['status' => 1,'use_time'=>time()]);
                }
                $uid=Db::table('cf_order')->where('id', $oid)->value('u_id');
                $is_first_order=Db::table('cf_customer')->where('id', $uid)->value('is_first_order');
                if($is_first_order==0){
                    $time=strtotime(date('Y-m-d'));

//						$data=['uid' => $uid, 'ticket_type' => 1,'amount'=>900,'status'=>2,'get_time'=>time(),'limit_time_end'=>$time+864000,'name'=>'9元现金券','limit_time_start'=>$time,'remark'=>'9元现金券','end_time'=>date('Y-m-d',time()+864000),'rule'=>'[{"type":1,"price":1000}]'];
//						$data1=['uid' => $uid, 'ticket_type' => 1,'amount'=>500,'status'=>2,'get_time'=>time(),'limit_time_end'=>$time+864000,'name'=>'5元现金券','limit_time_start'=>$time,'remark'=>'5元现金券','end_time'=>date('Y-m-d',time()+864000),'rule'=>'[{"type":1,"price":1000}]'];
//						$data2=['uid' => $uid, 'ticket_type' => 1,'amount'=>300,'status'=>2,'get_time'=>time(),'limit_time_end'=>$time+864000,'name'=>'3元现金券','limit_time_start'=>$time,'remark'=>'3元现金券','end_time'=>date('Y-m-d',time()+864000),'rule'=>'[{"type":1,"price":1000}]'];
//						$data3=['uid' => $uid, 'ticket_type' => 1,'amount'=>100,'status'=>2,'get_time'=>time(),'limit_time_end'=>$time+864000,'name'=>'1元现金券','limit_time_start'=>$time,'remark'=>'1元现金券','end_time'=>date('Y-m-d',time()+864000),'rule'=>'[{"type":1,"price":1000}]'];
//
//						Db::table('cf_cust_ticket')->insert($data);
//						Db::table('cf_cust_ticket')->insert($data1);
//						Db::table('cf_cust_ticket')->insert($data2);
//						Db::table('cf_cust_ticket')->insert($data3);

                    Db::table('cf_customer')
                        ->where('id', $uid)
                        ->update(['is_first_order' => 1,'first_order_time'=>time()]);
                }
                Db::table('cf_customer')
                    ->where('id', $uid)
                    ->setInc('sum_order');
                $did_arr=json_decode($mene_info);
                foreach($did_arr as $key=>$value){
                    $id=$value->id;
                    $num=$value->num;
                    // score 字段减 1
                    Db::table('cf_menu')
                        ->where('did', $id)
                        ->setDec('remain_num',$num);
                }


                Db::table('cf_customer')
                    ->where('open_id',cookie('open_id'))
                    ->setDec('cb_balance',$price);


                // 提交事务
                Db::commit();


            } catch (\PDOException $e) {
                // 回滚事务
                Db::rollback();
                $data = [ 'msg' => '服务器异常，请稍后再试'];
                return ['rtn' => 1, 'data' => $data];
            }

            $data = [ 'id' => $_POST['oid']];
            return ['rtn' => 0, 'data' => $data];
        }

    }
    //用户订单添加 TODO
    public function add_order(){
        $menu_info=$_POST['dids'];
        $coupon_id=$_POST['coupon'];
        $price=$_POST['price'];

        $ids='';
        $did_arr=json_decode($menu_info);
        foreach($did_arr as $key=>$value){
            $ids .=$value->id.",";
            $dish_map[$value->id]=$value->num;
        }
        $ids=rtrim($ids,",");
        $dish_day=Db::table('cf_menu')->where('did','in',$ids)->value('day');

        $uid=Db::table('cf_customer')->where('open_id',cookie('open_id'))->value('id');
        if($price>0) {
            $arr = ['u_id' => $uid, 'amount' => $price, 'status' => 0, 'commentstatus' => 0, 'createtime' => time(), 'menuinfo' => $menu_info, 'coupon_id' => $coupon_id, 'dish_day' => $dish_day, 'bank_no' => 'weixin'];
            Db::table('cf_order')->insert($arr);
            $cm_id = Db::getLastInsID();
            $cm_id = base64_encode($cm_id . 'xxjrcfid888');
            $data = ['cm_id' => $cm_id];
            return ['rtn' => 0, 'data' => $data];
        }else{
            return ['rtn' => 0, 'data' => []];
        }
    }

    //获取用户所有优惠券信息 TODO
    public function get_user_coupon_all(){
        $list[0]=['id'=>'471101','name'=>'0.5元现金券','price'=>'50','limit_time_start'=>'2016-05-19','limit_time_end'=>'2016-05-29','rule'=>'[{"type":1,"price":1000}]','remark'=>'0.5元现金券','code'=>'602382bd2c431f2489e38761df17f572','status'=>'0','alipay_id'=>'0','consume_id'=>'0','use_time'=>'0000-00-00 00:00:00','end_time'=>'2016-05-29','get_time'=>'2016-05-19 20:18:41'];
        $data=['list'=>$list,'today'=>'2016-06-07','page'=>'1','totalPage'=>1];
        return['rtn'=>0,'data'=>$data];
    }

    //获取用户所有订单信息 TODO
    public function get_order_list(){
        $page=$_GET['page'];
        $time=$_GET['time'];
        $type=$_GET['type'];
        if($time==1){
            $timein=time()-604800;

        }elseif($time==2){
            $timein=time()-2592000;

        }elseif($time==3) {
            $timein = time() - 31536000;

        }else{
            $timein=0;
        }


        $meal[1]=['name'=>"午餐",'meals_type'=>1,'time'=>"lunch_time",'pre'=>"10:00",'end'=>"10:30",'pay_time'=>"10:35",'team_pre'=>"10:00",'team_end'=>"10:30",'order_out_time_begin'=>"10:30",'order_out_time_end'=>"11:00",'PRE_DISCOUNT'=>200,'PRE_DISCOUNT2'=>150,'PRE_DISCOUNT_TIME'=>"09:45"];

        $uid=Db::table('cf_customer')->where('open_id',cookie('open_id'))->value('id');
        if($type==0){
            $order_info=Db::table('cf_order')->where('u_id',$uid)->where('createtime','GT',$timein)->page($page,5)->order('id desc')->select();
        }else{
            $order_info=Db::table('cf_order')->where('u_id',$uid)->where('createtime','GT',$timein)->where('meals_type',$type)->page($page,5)->order('id desc')->select();
        }
        $count=Db::table('cf_order')->where('u_id',$uid)->count();
        $list=array();
        if(!empty($order_info)) {
            foreach ($order_info as $key => $value) {
                $did_arr = json_decode($value['menuinfo']);
                $list[$key] = Db::table('cf_order')->where('id', $value['id'])->field("amount price,status,pay_type,bank_no,make_status,createtime time,dish_day,meals_type")->find();
                $list[$key]['createtime'] = date('Y-m-d h:m:s', $list[$key]['time']);
                $list[$key]['id'] = base64_encode($value['id'].'xxjrcfid888');
                $status=$list[$key]['status'];
                $id=$list[$key]['id'];
                $i = 0;
                foreach ($did_arr as $value) {

                    $list[$key]['order_list'][$i] = Db::table('cf_menu')->where('did', $value->id)->field("did id,dish_type meal_type,day dish_day,name dish_name,vip_price price")->find();

                    $list[$key]['order_list'][$i]['dish_num'] = $value->num;
                    $list[$key]['order_list'][$i]['oid'] = $id;
                    $list[$key]['order_list'][$i]['book_type'] = 1;
                    $list[$key]['order_list'][$i]['status'] = $status;
                    $list[$key]['order_list'][$i]['pay_type'] = 1;
                    $i++;
                }

            }
        }

        $totalPage=ceil($count/5);
        $data=['list'=>$list,'now_time'=>time(),'meal'=>$meal,'page'=>$page,'totalPage'=>$totalPage];
        return['rtn'=>0,'data'=>$data];
    }
    //取消订单并且返回资金 TODO
    public function cancel_order_cm(){
        $oid=base64_decode($_POST['id']);
        $oid= str_replace("xxjrcfid888",'',$oid);

        $uid=Db::table('cf_order')->where(['id' => $oid,'status'=>1])->value('u_id');
        if(empty($uid)){
            $data=['msg'=>'用户id为空'];
            return['rtn'=>4,'data'=>$data];
        }
        $pay_price=Db::table('cf_pay')->where(['oid' => $oid,'status'=>1])->value('pay_price');
        if(empty($pay_price)){
            $data=['msg'=>'支付金额为空'];
            return['rtn'=>4,'data'=>$data];
        }
        $pay_time=Db::table('cf_order')->where(['id' => $oid,'status'=>1])->value('paytime');
        if(empty($pay_time)){
            $data=['msg'=>'时间与订单不对应'];
            return['rtn'=>4,'data'=>$data];
        }
        Db::startTrans();
        try {
         $menu_info=Db::table('cf_order')->where('u_id',$uid)->where('id',$oid)->value('menuinfo');

            $did_arr = json_decode($menu_info);
            foreach($did_arr as $key=>$value){
                $id=$value->id;
                $num=$value->num;
                  Db::table('cf_menu')
                    ->where('did', $id)
                    ->setInc('remain_num',$num);
                $cm_info= Db::table('cf_menu')
                    ->where('did', $id)->find();
                $order_list[$key]=['id'=>$cm_info['id'],'meals_type'=>"1",'dish_did'=>$id,'dish_day'=>$cm_info['day'],'dish_name'=>$cm_info['name'],'dish_num'=>$num,'pay_type'=>"2","price"=>$cm_info['vip_price'],'status'=>"2",'make_status'=>'0','creattime'=> $pay_time];
                Db::table('cf_order_count')->where('uid',$uid)->where('cm_id',$id)->where('create_time',$pay_time)->delete();
            }

            Db::table('cf_customer')
                    ->where('id', $uid)
                    ->setInc('cb_balance',$pay_price);

            Db::table('cf_order_count_detail')
                ->where('oid', $oid)
                ->delete();

            Db::table('cf_order')
                ->where('id', $oid)
                ->update(['status'=>2]);

            Db::table('cf_pay')
                ->where('oid', $oid)
                ->update(['status'=>2]);

            $balance=Db::table('cf_customer')->where('id', $uid)->value('cb_balance');

            $order=Db::table('cf_order')->where(['id' => $oid])->field("status,pay_type,meals_type,coupon_id coupon_entity_id,amount price,bank_no,make_status,dish_day,createtime")->find();

            if(empty($order['coupon_entity_id'])){
                Db::table('cf_cust_ticket')
                    ->where('id', $order['coupon_entity_id'])
                    ->update(['status'=>1,'use_time'=>0]);
            }

            // 提交事务
            Db::commit();
            $order['id']=$_POST['id'];

            $order['creattime']=date('Y-m-d H:m:s',$order['createtime']);


            $order['order_list']=$order_list;
            $data=['order'=>$order,'balance'=>$balance];
            return['rtn'=>0,'data'=>$data];


        } catch (\PDOException $e) {
            // 回滚事务
            Db::rollback();
        }
    }

    public function cancel_order_cm_2(){

    }

    //获取订单详细信息 TODO
    public function get_order_status(){
       $oid=base64_decode($_GET['id']);;
        $oid= str_replace("xxjrcfid888",'',$oid);
        $order_info=Db::table('cf_order')
            ->alias('o')
            ->join('pay p','o.id = p.oid')
            ->join('cust_address a','a.u_id = o.u_id')
            ->join('company c','a.company_id = c.id')
            ->join('building b','c.building_id = b.id')
            ->field('o.paytime,o.finishtime,o.sendtime,o.meals_type,o.amount price,o.status,o.pay_type,o.bank_no,o.make_status,o.dish_day,o.createtime creattime,p.pay_price total_price,b.building_name addr_building_name,c.lunch_time addr_arrive,c.company addr_company_name,c.layer addr_layer,a.user_name ,a.phone addr_phone')
            ->where(['o.id' => $oid])->find();
        $order_info['id']=$_GET['id'];

        $menuinfo=Db::table('cf_order')->where(['id' => $oid])->value('menuinfo');

        $did_arr=json_decode($menuinfo);
        $i = 0;
        foreach($did_arr as $key=>$value){
           $id=$value->id;
           $num=$value->num;
            $data_list[$i]=Db::table('cf_menu')->where('did',$id)->field('name dish_name,vip_price price')->find();
            foreach ($data_list as $key2=>$value2){
                $data_list[$key2]['id']=$id;
                $data_list[$key2]['meals_type']=$order_info['meals_type'];
                $data_list[$key2]['dish_num']=$num;
                $data_list[$key2]['pay_type']=$order_info['pay_type'];
                $data_list[$key2]['status']=$order_info['status'];
                $data_list[$key2]['make_status']=$order_info['make_status'];
                $data_list[$key2]['addr_company_name']=$order_info['addr_company_name'];
                $data_list[$key2]['creattime']=$order_info['creattime'];
                $data_list[$key2]['addr_building_name']=$order_info['addr_building_name'];
                $data_list[$key2]['addr_arrive']=$order_info['addr_arrive'];
                $data_list[$key2]['addr_company_name']=$order_info['addr_company_name'];
                $data_list[$key2]['addr_layer']=$order_info['addr_layer'];
                $data_list[$key2]['user_name']=$order_info['user_name'];
                $data_list[$key2]['addr_phone']=$order_info['addr_phone'];

            }
            $i++;
        }
        if($order_info['creattime']!=0) {
            $status_list[0] = ['type' => '0', 'sub_type' => '', 'handle_type' => '0', 'handle_msg' => '', 'remark' => '', 'refund' => '0', 'coupon_entity_id' => '0', 'creattime' => date('Y-m-d H:m:s',$order_info['creattime']), 'handle_time' => date('Y-m-d H:m:s',$order_info['creattime'])];
        }
        if($order_info['paytime']!=0) {
            $status_list[1] = ['type' => '1', 'sub_type' => '', 'handle_type' => '0', 'handle_msg' => '', 'remark' => '', 'refund' => '0', 'coupon_entity_id' => '0', 'creattime' => date('Y-m-d H:m:s',$order_info['paytime']), 'handle_time' => date('Y-m-d H:m:s',$order_info['paytime'])];
        }
        if($order_info['sendtime']!=0) {
            $status_list[2] = ['type' =>'5', 'sub_type' => '', 'handle_type' => '0', 'handle_msg' => '', 'remark' => '', 'refund' => '0', 'coupon_entity_id' => '0', 'creattime' => date('Y-m-d H:m:s',$order_info['sendtime']), 'handle_time' => date('Y-m-d H:m:s',$order_info['sendtime'])];
        }
        if($order_info['finishtime']!=0) {
            $status_list[2] = ['type' =>'3', 'sub_type' => '', 'handle_type' => '0', 'handle_msg' => '', 'remark' => '', 'refund' => '0', 'coupon_entity_id' => '0', 'creattime' => date('Y-m-d H:m:s',$order_info['finishtime']), 'handle_time' => date('Y-m-d H:m:s',$order_info['finishtime'])];
        }
        $order_info['order_list']=$data_list;
        $order_info['status_list']=$status_list;
        $data=['info'=>$order_info];
        return['rtn'=>0,'data'=>$data,'order_info'=>$order_info];
    }

    public function csm_reminder_order(){

    }
    //添加用户评论  TODO
    public function add_dish_cmt(){
        $id=$_POST['id'];
        $oid=base64_decode($_POST['oid']);
        $score=$_POST['score'];
        $content=$_POST['content'];

        $oid= str_replace("xxjrcfid888",'',$oid);
        $oid=Db::table('cf_order')->where(['id' => $oid,'status'=>1])->value('id');
        if(empty($oid)){
            die('非法操作');
        }else{
            $c_id=Db::table('cf_comment')->where(['oid' => $oid,'did'=>$id])->value('id');
          if(empty($c_id)) {
              Db::table('cf_comment')->insert(['did' => $id, 'oid' => $oid, 'score' => $score, 'content' => $content, 'open_id' => cookie('open_id'), 'create_time' => time()]);
          }else{
              $data=['msg'=>'您已经点评过了，感谢您的支持'];
              return['rtn'=>1,'data'=>$data];
          }
        }


        $data=['msg'=>'success'];
        return['rtn'=>0,'data'=>$data];
    }

    public function check_building_discount(){
        $meals_type_info[1]=['name'=>"午餐",'meals_type'=>1,'time'=>"lunch_time",'pre'=>"10:00",'end'=>"10:30",'pay_time'=>"10:35",'team_pre'=>	"10:00",'team_end'=>"10:30",'order_out_time_begin'=>"10:30",'order_out_time_end'=>"11:00",'PRE_DISCOUNT'=>500,'PRE_DISCOUNT2'=>150,'PRE_DISCOUNT_TIME'=>"09:45"];
        $deliv_time_info=['day'=>"2016-06-12",'time'=>"18:00前"];
        $info=['lunch_status'=>1,'dinner_status'=>0,'discount'=>0,'list'=>'[]','is_new'=>false ,'bulidJoin'=>'','deliv_time_info'=>$deliv_time_info,'meals_type_info'=>$meals_type_info];
        $data=['info'=>$info];
        return['rtn'=>0,'data'=>$data];
    }
    public function apply_building(){
        $building=$_POST['building'];
        $company=$_POST['company'];
        $layer=$_POST['layer'];
        $phone=$_POST['phone'];
        $remark=$_POST['remark'];

        if(empty($layer)){
            $layer=0;
        }
        $data= Db::table('cf_apply_building')->insert(['build_name'=>$building,'company'=>$company,'phone'=>$phone,'layer'=>$layer,'remark'=>$remark,'apply_time'=>time()]);
        return['rtn'=>0,'data'=>$data];

    }

    // 关闭订餐提醒 TODO
    public function userinfo_edit(){
        $status=$_POST['status'];
        Db::table('cf_customer')
            ->where('open_id', cookie('open_id'))
            ->update(['is_push'=>$status]);

        $data=['msg'=>'success'];
        return['rtn'=>0,'data'=>$data];
    }

    //设置饭粒账户支付密码 TODO
    public function set_pay_pwd(){
        $pwd=$_POST['pwd'];
        Db::table('cf_customer')->where('open_id',cookie('open_id'))->update(['password'=>$pwd]);

        $data=['msg'=>'success'];
        return['rtn'=>0,'data'=>$data];
    }


}
