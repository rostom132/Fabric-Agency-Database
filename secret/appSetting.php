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
                'name' => '/^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s]+$/',
                'name_error_response' => 'Name only contains letters',
                'address' => '/^[\/a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s|_,]+$/',
                'address_error_response' => 'Address only contain letters and characters like |_,',
                'bank_account' => '/^\w{5,30}$/',
                'bank_account_error_response' => 'Bank account has minimum of 5 digtis and maxium of 30 digits',
                'tax' => '/^\w{5,30}/',
                'tax_error_response' => 'Tax code has minimum of 5 digits and maxium of 30 digits'
            ),
            'supplier_phonenumber' => array (
                'phone' => '/^\d{10}$/',
            ), 

        )

    );
?>
