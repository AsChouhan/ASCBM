@isTest
private class PaymentGatewayApexTest {
    @isTest
    static void testpayByCreditCard(){
        
        Test.setMock(HttpCalloutMock.class, new paymentgatewayMockclass());
        String cardNumber = '3566000020000410';
        String amount = '10000';
        String cardMonth = '05';
        String cardYear = '2023';
        String cvv = '123';

        String result = PaymentGatewayApex.payByCreditCard(cardNumber, amount, cardMonth, cardYear, cvv);
        System.assertEquals('This transaction has been approved.', result);
    }
    
    @isTest
    static void testpayByEcheck(){
        Test.setMock(HttpCalloutMock.class, new paymentgatewayMockclass());
        String routingNumber = '11114253688';
        String accountNumber = '98876925583';
        String nameOnAccount = 'aasheesh singh chouhan';
        
        String result = PaymentGatewayApex.payByEcheck(routingNumber, accountNumber, nameOnAccount);
        System.assertEquals('This transaction has been approved.', result);
    }
}