using Microsoft.Azure.Storage.Blob;
using System.Threading.Tasks;

namespace FunctionApp1.Helpers
{
    public interface IGameImport
    {
        Task ExecuteAsync(
            CloudBlobContainer cloudBlobContainer,
            string userName);
    }
}
