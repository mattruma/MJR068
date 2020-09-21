using FunctionApp1.Helpers;
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
    public class GameImportHttpTrigger
    {
        private readonly IGameImport _gameImport;

        public GameImportHttpTrigger(
            IGameImport gameImport)
        {
            _gameImport = gameImport;
        }

        [FunctionName(nameof(GameImportHttpTrigger))]
        public async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req,
            [Blob("collections", FileAccess.ReadWrite, Connection = "StorageConnectionString")] CloudBlobContainer cloudBlobContainer,
            ILogger log)
        {
            log.LogInformation($"{nameof(GameImportHttpTrigger)} processed a request.");

            await _gameImport.ExecuteAsync(cloudBlobContainer, "raz0rf1sh");

            return new OkResult();
        }
    }
}
