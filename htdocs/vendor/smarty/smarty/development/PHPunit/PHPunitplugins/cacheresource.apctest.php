<?php

require_once SMARTY_DIR . '../demo/plugins/cacheresource.apc.php';

class Smarty_CacheResource_Apctest extends Smarty_CacheResource_Apc {
    public function get(Smarty_Internal_Template $_template)
    {
        $this->contents = array();
        $this->timestamps = array();
        $t = $this->getContent($_template);
        return $t ? $t : null;
    }
    
    public function __sleep()
    {
        return array();
    }
    
    public function __wakeup()
    {
        $this->__construct();
    }
}