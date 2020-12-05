<?php
    return array (
        // mapping key value into column name in database
        'key_map' => array (
            'supplier' => array(
                'supplierCode' => 'ID',
                'supplierName' => 'name',
                'address' => 'address',
                'bankAccount' => 'bank_account',
                'taxCode' => 'tax'
            ),
            'supplier_phonenumber' => array(
                'supplierCode' => 'ID',
                'phoneNumber' => 'phone'
            )
        ),


        // validation every data insert into database 
        'validation' => array(
            'supplier' => array (
                'name' => '/^[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s|_]+$/',
                'address' => '/^[\/a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s|_]+$/',
                'bank_account' => '/^\w{5,30}$/',
                'tax' => '/^\w{5,30}/'
            ),
            'supplier_phonenumber' => array (
                'phone' => '/^\d{10}$/',
            ), 

        )

    );
?>
