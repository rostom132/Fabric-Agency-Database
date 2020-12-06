<?php
    class Config {

        static function getConfig() {
            return require "appConfig.php";
        }

        static function getAppSetting() {
            return require "appSetting.php";
        }

        static function getDbConfig() {
            return Config::getConfig()['configDB'];
        }

        static function getKeyMap() {
            return Config::getAppSetting()['key_map'];
        }

        static function getRegex() {
            return Config::getAppSetting()['validation'];
        }

    }

?>
