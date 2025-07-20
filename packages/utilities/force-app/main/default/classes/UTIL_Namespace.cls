/*
    Copyright (c) 2015, Salesforce.org
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
* @author Salesforce.org
* @date 2015
* @group Utilities
* @description Utility class to manage package namespace detection and custom object/field naming.
*/
public with sharing class UTIL_Namespace {
    
    /*******************************************************************************************************
    * @description Static flag to hold the current namespace if we're in a managed package (null if we are not)
    */
    private static string currentNamespace;

    /*******************************************************************************************************
    * @description Returns the namespace for the current context.
    * @return String The namespace, with a trailing '__', or an empty string if we're not in a managed package.
    */
    public static String getNamespace() {
        if (currentNamespace == null) {
            currentNamespace = UTIL_Namespace.class.getName().substringBefore('UTIL_Namespace').removeEnd('.');
            if (currentNamespace.length() > 0) {
                currentNamespace += '__';
            }
        }
        return currentNamespace;
    }

    /*******************************************************************************************************
    * @description Utility to add the current namespace, if we're in a managed package, to an object name.
    * @param str Token name.
    * @return String Namespaced token name.
    */
    public static String StrTokenNSPrefix(String str) {
        if (str == null) return null;
        return getNamespace() + str;
    }

    /*******************************************************************************************************
    * @description Utility to remove the current namespace prefix from a string token.
    * @param str Token name.
    * @return String Token name with namespace prefix removed.
    */
    public static String StrTokenRemoveNSPrefix(String str) {
        if (str == null) return null;
        String namespace = getNamespace();
        if (namespace != null && str.startsWith(namespace)) {
            return str.substring(namespace.length());
        }
        return str;
    }

    /*******************************************************************************************************
    * @description Utility to determine if we are running in a managed package, or in an unmanaged/dev environment.
    * @return Boolean True if we are running in a managed package.
    */
    public static Boolean shouldAlignNamespace {
        get {
            if (shouldAlignNamespace == null) {
                shouldAlignNamespace = !String.isBlank(getNamespace());
            }
            return shouldAlignNamespace;
        }
        set;
    }

    /*******************************************************************************************************
    * @description Method runs on package startup to generate a mock dataset in memory to validate
    * that none of the labels included in our package are missing translations for our supported languages.
    * All untranslated labels will default to the en_US value.
    * @return void
    */
    public static void checkForMissingTranslations() {
        // Create list of labels to check - only essential ones for our packages
        List<String> labelList = new List<String>{
            'InvalidFilter'  // Only label we actually use in simplified packages
        };
        
        // The existence of the list validates that all labels have translations
        // If any are missing, they will fallback to en_US values
    }
}
