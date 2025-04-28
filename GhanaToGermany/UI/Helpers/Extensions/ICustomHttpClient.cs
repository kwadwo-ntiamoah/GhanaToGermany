using Newtonsoft.Json;
using System.Text;

namespace UI.Helpers.Extensions;

public interface ICustomHttpClient
    {
        public Task<T?> GetAsync<T>(string path);
        public Task<T?> PostAsync<P, T>(string path, P payload);
        public Task<T?> PostAsyncMultiPartFormData<T>(string path, MultipartFormDataContent payload);
    }

    public class CustomHttpClient(HttpClient client, ILogger<CustomHttpClient> logger) : ICustomHttpClient
    {
        /// <summary>
        /// Get Async Summary
        /// </summary>
        /// <typeparam name="T">Return Type</typeparam>
        /// <param name="path">endpoint path to push Get request</param>
        /// <returns></returns>
        public async Task<T?> GetAsync<T>(string path)
        {
            try
            {
                // Log the request URL for better visibility
                logger.LogInformation("Sending GET request to {Url}", path);

                var response = await client.GetAsync(path);

                if (!response.IsSuccessStatusCode)
                {
                    // Capture the error response
                    var jsonError = await response.Content.ReadAsStringAsync();
                    var problemDetails = JsonConvert.DeserializeObject<ProblemDetails>(jsonError);

                    // Log the error details before throwing
                    logger.LogError("HTTP Error {StatusCode}: {ErrorDetails}", response.StatusCode, jsonError);

                    // Throw a detailed exception with the error message
                    throw new Exception(problemDetails?.Title ?? "Unknown Error");
                }

                if (response.StatusCode == System.Net.HttpStatusCode.Unauthorized)
                {
                    throw new Exception("Login timed-out");
                }

                // Log the response data if needed (for debugging)
                var jsonData = await response.Content.ReadAsStringAsync();
                logger.LogInformation("Received response: {Response}", jsonData);

                logger.LogInformation("==================================================");
                logger.LogInformation("Deserializing object of type {type}", typeof(T));
                logger.LogInformation("==================================================");

                // Deserialize the response data
                if (typeof(T) == typeof(string))
                {
                    return (T)(object)jsonData;
                }

                var data = JsonConvert.DeserializeObject<T>(jsonData);

                // Return the deserialized data
                return data;
            }
            catch (HttpRequestException httpEx)
            {
                // Handle network-related issues
                logger.LogError(httpEx, "Network error while making GET request to {Url}", path);
                throw new Exception("Network error occurred during the HTTP request.", httpEx);
            }
            catch (JsonException jsonEx)
            {
                // Handle issues with JSON deserialization
                logger.LogError(jsonEx, "Error deserializing response from {Url}", path);
                throw new Exception("Error deserializing the response data.", jsonEx);
            }
            catch (Exception ex)
            {
                // Log any other exceptions that might occur
                logger.LogError(ex, "An error occurred while making GET request to {Url}", path);
                throw; // Re-throw the exception to be handled upstream
            }
        }

        /// <summary>
        /// PostAsync Summary
        /// </summary>
        /// <typeparam name="T">T represents the type of the response</typeparam>
        /// <typeparam name="P">P represents the type of the payload</typeparam>
        /// <param name="path"></param>
        /// <param name="payload"></param>
        /// <returns></returns>
        public async Task<T?> PostAsync<P, T>(string path, P? payload)
        {
            try
            {
                // Log the request URL and payload for better visibility
                logger.LogInformation("Sending POST request to {Url} with payload: {Payload}", path,
                    JsonConvert.SerializeObject(payload));

                // Create the HTTP request content: if payload is null, use an empty object or null content
                HttpContent? content = payload != null
                    ? new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json")
                    : new StringContent(string.Empty);

                // Send the POST request with the payload (or no content if payload is null)
                var response = await client.PostAsync(path, content);

                if (!response.IsSuccessStatusCode)
                {
                    // Capture the error response
                    var jsonError = await response.Content.ReadAsStringAsync();
                    var problemDetails = JsonConvert.DeserializeObject<ProblemDetails>(jsonError);

                    // Log the error details before throwing
                    logger.LogError("HTTP Error {StatusCode}: {ErrorDetails}", response.StatusCode, jsonError);

                    // Throw a detailed exception with the error message
                    throw new Exception(problemDetails?.Title ?? "Unknown Error");
                }

                // Log the response data if needed (for debugging purposes)
                var jsonData = await response.Content.ReadAsStringAsync();
                logger.LogInformation("Received response: {Response}", jsonData);

                if (string.IsNullOrEmpty(jsonData)) return default;

                // Deserialize the response data into the desired type
                var data = JsonConvert.DeserializeObject<T>(jsonData);

                // Return the deserialized data
                return data;
            }
            catch (HttpRequestException httpEx)
            {
                // Handle network-related issues (timeouts, unreachable server, etc.)
                logger.LogError(httpEx, "Network error while making POST request to {Url} with payload: {Payload}",
                    path, JsonConvert.SerializeObject(payload));
                throw new Exception("Network error occurred during the HTTP request.", httpEx);
            }
            catch (JsonException jsonEx)
            {
                // Handle issues with JSON deserialization
                logger.LogError(jsonEx, "Error deserializing response from {Url} with payload: {Payload}", path,
                    JsonConvert.SerializeObject(payload));
                throw new Exception("Error deserializing the response data.", jsonEx);
            }
            catch (Exception ex)
            {
                // Log any other exceptions that might occur
                logger.LogError(ex, "An error occurred while making POST request to {Url} with payload: {Payload}",
                    path, JsonConvert.SerializeObject(payload));
                throw; // Re-throw the exception to be handled by the caller
            }
        }

        public async Task<T?> PostAsyncMultiPartFormData<T>(string path, MultipartFormDataContent payload)
        {
            try
            {
                // Log the request URL and payload for better visibility
                logger.LogInformation("Sending POST request to {Url} with payload: {Payload}", path,
                    JsonConvert.SerializeObject(payload));

                // Send the POST request with the payload (or no content if payload is null)
                var response = await client.PostAsync(path, payload);

                if (!response.IsSuccessStatusCode)
                {
                    // Capture the error response
                    var jsonError = await response.Content.ReadAsStringAsync();
                    var problemDetails = JsonConvert.DeserializeObject<ProblemDetails>(jsonError);

                    // Log the error details before throwing
                    logger.LogError("HTTP Error {StatusCode}: {ErrorDetails}", response.StatusCode, jsonError);

                    // Throw a detailed exception with the error message
                    throw new Exception(problemDetails?.Title ?? "Unknown Error");
                }

                // Log the response data if needed (for debugging purposes)
                var jsonData = await response.Content.ReadAsStringAsync();
                logger.LogInformation("Received response: {Response}", jsonData);

                // Deserialize the response data into the desired type
                var data = JsonConvert.DeserializeObject<T>(jsonData);

                // Return the deserialized data
                return data;
            }
            catch (HttpRequestException httpEx)
            {
                // Handle network-related issues (timeouts, unreachable server, etc.)
                logger.LogError(httpEx, "Network error while making POST request to {Url} with payload: {Payload}",
                    path, JsonConvert.SerializeObject(payload));
                throw new Exception("Network error occurred during the HTTP request.", httpEx);
            }
            catch (JsonException jsonEx)
            {
                // Handle issues with JSON deserialization
                logger.LogError(jsonEx, "Error deserializing response from {Url} with payload: {Payload}", path,
                    JsonConvert.SerializeObject(payload));
                throw new Exception("Error deserializing the response data.", jsonEx);
            }
            catch (Exception ex)
            {
                // Log any other exceptions that might occur
                logger.LogError(ex, "An error occurred while making POST request to {Url} with payload: {Payload}",
                    path, JsonConvert.SerializeObject(payload));
                throw; // Re-throw the exception to be handled by the caller
            }
        }

        public class ProblemDetails
        {
            public string Type { get; set; } = string.Empty;
            public string Title { get; set; } = string.Empty;
            public int Status { get; set; }
            public string TraceId { get; set; } = string.Empty;
        }
    }