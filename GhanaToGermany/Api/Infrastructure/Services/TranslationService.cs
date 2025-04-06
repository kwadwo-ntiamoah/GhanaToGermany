using System.Net;
using System.Net.Http.Headers;
using Api.Domain;
using Newtonsoft.Json;

namespace Api.Infrastructure.Services
{
    public class TranslationService
    {
        private readonly HttpClient _client;
        private readonly IConfiguration _config;

        public TranslationService(IConfiguration config)
        {
            _config = config;

            _client = new HttpClient
            {
                BaseAddress = new Uri(_config["TRANSLATION:BASE_URL"]!)
            };
            _client.DefaultRequestHeaders
              .Accept
              .Add(new MediaTypeWithQualityHeaderValue("application/json"));
            _client.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", _config["TRANSLATION:API_KEY"]);
        }

        public async Task<string> TranslateText(string text)
        {
            var request = new HttpRequestMessage(HttpMethod.Post, _config["TRANSLATION:BASE_URL"]);
            request.Headers.Add("Ocp-Apim-Subscription-Key", _config["TRANSLATION:API_KEY"]);

            var payload = new TranslationDto
            {
                In = text
            };

            var jsonPayload = JsonConvert.SerializeObject(payload);

            var content = new StringContent(jsonPayload, null, "application/json");
            request.Content = content;

            var tempResponse = await _client.SendAsync(request);

            var chq = await tempResponse.Content.ReadAsStringAsync();

            tempResponse.EnsureSuccessStatusCode();

            if (tempResponse.StatusCode != HttpStatusCode.OK)
            {
                throw new Exception(await tempResponse.Content.ReadAsStringAsync());
            }

            return JsonConvert.DeserializeObject<string>(chq);
        }

        private class TranslationDto
        {
            [JsonProperty("in")]
            public string? In { get; set; }

            [JsonProperty("lang")]
            public string Lang { get; set; } = "en-tw";
        }
    }


}