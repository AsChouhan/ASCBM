// [SERVICE] BOX1
// [OBJECT] BOX1.BOXhT.OUT.2XX.entries

global class BoxEntriesTemp {
    
    
    // [PROPERTY] sha1
    @AuraEnabled
    global String sha1 {get; set{ this.sha1 = value; this.sha1_set = true; }}
    @AuraEnabled
    global Boolean sha1_set {get; set;}
    
    // [PROPERTY] file_version
    @AuraEnabled
    global fileVersion filex5fversion {get; set{ this.filex5fversion = value; this.filex5fversion_set = true; }}
    @AuraEnabled
    global Boolean filex5fversion_set {get; set;}
    
    // [PROPERTY] sequence_id
    @AuraEnabled
    global String sequencex5fid {get; set{ this.sequencex5fid = value; this.sequencex5fid_set = true; }}
    @AuraEnabled
    global Boolean sequencex5fid_set {get; set;}
    
    // [PROPERTY] name
    @AuraEnabled
    global String name {get; set{ this.name = value; this.name_set = true; }}
    @AuraEnabled
    global Boolean name_set {get; set;}
    
    // [PROPERTY] etag
    @AuraEnabled
    global String etag {get; set{ this.etag = value; this.etag_set = true; }}
    @AuraEnabled
    global Boolean etag_set {get; set;}
    
    // [PROPERTY] id
    @AuraEnabled
    global String id {get; set{ this.id = value; this.id_set = true; }}
    @AuraEnabled
    global Boolean id_set {get; set;}
    
    // [PROPERTY] type
    @AuraEnabled
    global String z0type {get; set{ this.z0type = value; this.z0type_set = true; }}
    @AuraEnabled
    global Boolean z0type_set {get; set;}
}