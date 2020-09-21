using Microsoft.Azure.Storage.Blob;
using System.Net.Http;
using System.Threading.Tasks;

namespace FunctionApp1.Helpers
{
    public class GameImport : IGameImport
    {
        private readonly HttpClient _httpClient;

        public GameImport(
            HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task ExecuteAsync(
            CloudBlobContainer cloudBlobContainer,
            string userName)
        {
            var response =
                await _httpClient.GetAsync($"https://bgg-json.azurewebsites.net/collection/{userName}");

            response.EnsureSuccessStatusCode();

            string body = await response.Content.ReadAsStringAsync();

            var blobName = $"{userName}.json";

            var cloudBlockBlob =
                cloudBlobContainer.GetBlockBlobReference(blobName);

            cloudBlockBlob.Properties.ContentType = "application/json";

            await cloudBlockBlob.UploadTextAsync(body);
        }
    }
}
