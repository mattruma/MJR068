using FunctionApp1.Helpers;
using Microsoft.Azure.Storage.Blob;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using System.IO;
using System.Threading.Tasks;

namespace FunctionApp1
{
    public class GameImportTimerTrigger
    {
        private readonly IGameImport _gameImport;

        public GameImportTimerTrigger(
            IGameImport gameImport)
        {
            _gameImport = gameImport;
        }

        [FunctionName(nameof(GameImportTimerTrigger))]
        public async Task Run([TimerTrigger("0 0 10 * * *")] TimerInfo myTimer,
            [Blob("collections", FileAccess.ReadWrite, Connection = "StorageConnectionString")] CloudBlobContainer cloudBlobContainer,
            ILogger log)
        {
            log.LogInformation($"{nameof(GameImportHttpTrigger)} processed a request.");

            await _gameImport.ExecuteAsync(cloudBlobContainer, "raz0rf1sh");
        }
    }
}
