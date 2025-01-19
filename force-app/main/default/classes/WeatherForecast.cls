/**
 * Created by mihir.agarwal on 19/01/25.
 */

public with sharing class WeatherForecast {

    @InvocableMethod(callout = true label = 'Call api for weather forecast'
            description = 'Flow to send mails for weather forecast')
    public static void callApiAndNotify(List<LocationInput> loc1) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        LocationInput loc = loc1.get(0);
        String latitude = loc.latitude;
        String longitude = loc.longitude;
        List<String> times = new List<String>();
        List<Double> temperatures = new List<Double>();

        try {
            String endpoint = 'https://api.open-meteo.com/v1/forecast?latitude=' + latitude + '&longitude=' + longitude + '&hourly=temperature_2m';
            request.setEndpoint(endpoint);
            request.setMethod('GET');

            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                if (jsonResponse.containsKey('hourly')) {
                    Map<String, Object> hourlyData = (Map<String, Object>) jsonResponse.get('hourly');
                    if (hourlyData.containsKey('time') && hourlyData.containsKey('temperature_2m')) {
                        List<Object> rawTimes = (List<Object>) hourlyData.get('time');
                        for (Object obj : rawTimes) {
                            times.add((String) obj);
                        }

                        List<Object> rawTemperatures = (List<Object>) hourlyData.get('temperature_2m');
                        for (Object obj : rawTemperatures) {
                            temperatures.add((Double) obj);
                        }
                    }
                }

                sendEmail(
                        'Weather forecast API Call Successful',
                        'The weather API call was completed successfully.\n\n' +
                                'Here are the latest details:\n' +
                                '- Time: ' + times.get(0) + '\n' +
                                '- Temperature: ' + temperatures.get(0) + '°C\n\n' +
                                'Stay updated with the latest forecasts. For more details, check the weather dashboard.\n\n' +
                                'Best regards,\n' +
                                'The Weather App Team'
                );
            } else {
                sendEmail('Weather forecast API call failed', 'The API call failed with status code: ' + response.getStatusCode() + '\n'+
                        'Best regards,\n' +
                        'The Weather App Team');
            }
        } catch (Exception e) {
            sendEmail('Weather forecast API call failed', 'An error occurred: ' + e.getMessage()+ '\n'+
                    'Best regards,\n' +
                    'The Weather App Team');
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

    public class LocationInput {
        @InvocableVariable(label='Enter_latitude' description='Latitude value')
        public String latitude;

        @InvocableVariable(label='Enter_longitude' description='Longitude value')
        public String longitude;
    }
}
