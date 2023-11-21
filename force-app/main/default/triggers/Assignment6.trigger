trigger Assignment6 on Lead (After insert) {
    Assignment6.DpRecord(Trigger.new);
}