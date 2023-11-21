<aura:application extends="force:slds">
    <c:sObjectLookup fieldLabel = "Contact" objectAPIName = "Contact"
                     fieldAPIName = "Name" subHeadingFieldsAPI = "Email,Phone"
                     lookupIcon = "standard:contact" placeholder = "Search Contact"/>
</aura:application>