/**
 * Created by mihir.agarwal on 17/01/25.
 */

public class ApiCalloutHandler {
    @InvocableMethod(callout = true label = 'Send email using slider'
            description = 'flow to send mails on different possible outcomes')
    public static void callApiAndNotify() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        try {
            request.setEndpoint('https://jsonplaceholder.typicode.com/posts/1');
            request.setMethod('GET');

            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
                sendEmail('API call successful', 'The API call was successful. Response: ' + response.getBody());
            } else {
                sendEmail('API call failed', 'The API call failed with status code: ' + response.getStatusCode());
            }
        } catch (Exception e) {
            sendEmail('API call failed', 'An error occurred: ' + e.getMessage());
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