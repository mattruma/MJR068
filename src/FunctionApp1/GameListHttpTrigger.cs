using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Storage.Blob;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System.IO;
using System.Threading.Tasks;

namespace FunctionApp1
{
    public static class GameListHttpTrigger
    {
        [FunctionName(nameof(GameListHttpTrigger))]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            [Blob("collections", FileAccess.ReadWrite, Connection = "StorageConnectionString")] CloudBlobContainer cloudBlobContainer,
            ILogger log)
        {
            log.LogInformation($"{nameof(GameListHttpTrigger)} processed a request.");

            var userName = "raz0rf1sh";

            var blobName = $"{userName}.json";

            var cloudBlockBlob =
                cloudBlobContainer.GetBlockBlobReference(blobName);

            cloudBlockBlob.Properties.ContentType = "application/json";

            var ms = new MemoryStream();

            await cloudBlockBlob.DownloadToStreamAsync(ms);

            return new FileContentResult(ms.ToArray(), cloudBlockBlob.Properties.ContentType);
        }
    }
}
