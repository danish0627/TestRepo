public with sharing class IMDB_controller {

    private static final String BASE_URL = 'http://www.omdbapi.com/';
    private static final String API_KEY = '26645a71'; // insert your own API key here

    @AuraEnabled(cacheable=true)
    public static List<Movie> searchMovies(String searchTerm) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(BASE_URL+'?apikey=' + API_KEY + '&s=' + EncodingUtil.urlEncode(searchTerm, 'UTF-8'));
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> searchResults = (List<Object>) data.get('Search');

            List<Movie> movies = new List<Movie>();
            for (Object result : searchResults) {
                Map<String, Object> resultData = (Map<String, Object>) result;
                Movie movie = new Movie();
                movie.title = (String) resultData.get('Title');
                movie.year = (String) resultData.get('Year');
                movie.poster = (String) resultData.get('Poster');
                movie.imdbId = (String) resultData.get('imdbID');
                movie.plot = (String) resultData.get('Plot');
                movie.country = (String) resultData.get('genre');
                movies.add(movie);
            }

            return movies;
        }

        return null;
    }

    
}