/**
 * Created by mihir.agarwal on 17/01/25.
 */

public class ApiCalloutHandlerNumber {
    @InvocableMethod(callout = true label = 'Send email using number'
            description = 'Flow to send mails on different possible outcomes')
    public static void callApiAndNotify(List<Integer> inputNumbers) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        for (Integer numbr : inputNumbers) {
            try {
                String endpoint = 'https://jsonplaceholder.typicode.com/posts/' + numbr;
                request.setEndpoint(endpoint);
                request.setMethod('GET');

                HttpResponse response = http.send(request);

                if (response.getStatusCode() == 200) {
                    sendEmail('API call successful',
                            'The API call to ' + endpoint + ' was successful. Response: ' + response.getBody());
                } else {
                    sendEmail('API call failed',
                            'The API call to ' + endpoint + ' failed with status code: ' + response.getStatusCode());
                }
            } catch (Exception e) {
                sendEmail('API call failed',
                        'An error occurred while calling ' + 'https://jsonplaceholder.typicode.com/posts/' + numbr +
                                ': ' + e.getMessage());
            }
        }
    }

    private static void sendEmail(String subject, String body) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] {'amihir1311@gmail.com'});
        email.setSubject(subject);
        email.setPlainTextBody(body);

        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        } catch (Exception e) {
            System.debug('Failed to send email: ' + e.getMessage());
        }
    }
}
