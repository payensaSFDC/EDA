/*
    Copyright (c) 2014 Salesforce.org
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Salesforce.org nor the names of
      its contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
    COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
*/
/**
* @author Salesforce Foundation
* @date 2014
* @group Utilities
* @description This class allows easy access to object and field description information from within other classes.
*
* It is called statically, and therefore will supply the same information to all calls made from
* within the same transaction, or set of trigger calls. This is beneficial because this info should
* be the same for all calls in a transaction, and by calling it statically we reduce the calls
* that are made, making the total transaction more efficient.
*/
public class UTIL_Describe {

    //maps to hold the describe info
    private static Map<String, Schema.SObjectType> gd;
    private static Map<String, Schema.DescribeSObjectResult> objectDescribes = new Map<String, Schema.DescribeSObjectResult>();
    private static Map<String, Map<String, Schema.SObjectField>> fieldTokens = new Map<String, Map<String, Schema.SObjectField>>();
    private static Map<String, Map<String, Schema.DescribeFieldResult>> fieldDescribes = new Map<String, Map<String, Schema.DescribeFieldResult>>();

    /*******************************************************************************************************
    * @description Returns the describe result of the specified SObject
    * @param objectName the name of the object to look up
    * @return Schema.DescribeSObjectResult of the object
    */
    public static Schema.DescribeSObjectResult getObjectDescribe(String objectName) {
        if (gd == null) gd = Schema.getGlobalDescribe();

        Schema.DescribeSObjectResult objResult = objectDescribes.get(objectName);
        if (objResult == null) {
            Schema.SObjectType objToken = gd.get(objectName);
            if (objToken != null) {
                objResult = objToken.getDescribe();
                objectDescribes.put(objectName, objResult);
            }
        }
        return objResult;
    }

    /*******************************************************************************************************
    * @description Returns the describe result of the specified field for the object
    * @param objectName the name of the object to look up
    * @param fieldName the name of the field to look up
    * @return Schema.DescribeFieldResult of the field, or null if not found
    */
    public static Schema.DescribeFieldResult getFieldDescribe(String objectName, String fieldName) {
        Schema.DescribeFieldResult dfr = null;
        Map<String, Schema.DescribeFieldResult> fieldMap = fieldDescribes.get(objectName);
        if (fieldMap == null) {
            fieldMap = new Map<String, Schema.DescribeFieldResult>();
            fieldDescribes.put(objectName, fieldMap);
        } else {
            dfr = fieldMap.get(fieldName);
        }
        
        if (dfr == null) {
            Map<String, Schema.SObjectField> objFieldMap = getFieldsMap(objectName);
            if (objFieldMap != null && objFieldMap.containsKey(fieldName)) {
                dfr = objFieldMap.get(fieldName).getDescribe();
                fieldMap.put(fieldName, dfr);
            }
        }
        return dfr;
    }

    /*******************************************************************************************************
    * @description Returns a map of all field names (keys) to field tokens (values) for a given SObject.
    * @param objectName the name of the object to look up
    * @return Map<String, Schema.SObjectField> of fieldname-to-fieldtoken pairs for the object
    */
    public static Map<String, Schema.SObjectField> getFieldsMap(String objectName) {
        Map<String, Schema.SObjectField> objFieldMap = fieldTokens.get(objectName);
        if (objFieldMap == null) {
            Schema.DescribeSObjectResult objDescribe = getObjectDescribe(objectName);
            if (objDescribe != null) {
                objFieldMap = objDescribe.fields.getMap();
                fieldTokens.put(objectName, objFieldMap);
            }
        }
        return objFieldMap;
    }

    /*******************************************************************************************************
    * @description Checks whether the object and field exist and can be accessed by the running user
    * @param objectName the name of the object to look up
    * @param fieldName the name of the field to look up  
    * @return Boolean true if the field is valid and accessible
    */
    public static boolean isValidField(String objectName, String fieldName) {
        Schema.DescribeFieldResult dfr = getFieldDescribe(objectName, fieldName);
        return dfr != null;
    }

    /*******************************************************************************************************
    * @description Custom exception class for describe operations
    */
    public class SchemaDescribeException extends Exception {}
}
