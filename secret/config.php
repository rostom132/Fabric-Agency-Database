<?php
    class Config {

        static function getConfig() {
            return require "appConfig.php";
        }

        static function getDbConfig() {
            return Config::getConfig()['configDB'];
        }

    }

?>