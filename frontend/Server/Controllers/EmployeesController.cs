using Microsoft.AspNetCore.Mvc;
using frontend.Shared;

namespace frontend.Server.Controllers;

[ApiController]
[Route("[controller]")]
public class EmployeesController : ControllerBase
{
    private readonly ILogger<EmployeesController> _logger;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly string _employeesServiceBaseUri;

    public EmployeesController(ILogger<EmployeesController> logger, IHttpClientFactory httpClientFactory, IConfiguration configuration)
    {
        _logger = logger;
        _httpClientFactory = httpClientFactory;
        _employeesServiceBaseUri = configuration.GetValue<string>("EmployeesServiceBaseUri");
    }

    [HttpGet]
    public async Task<IEnumerable<Employee>> Get()
    {
        var client = _httpClientFactory.CreateClient();
        var employees = await client.GetFromJsonAsync<IEnumerable<Employee>>(_employeesServiceBaseUri);
        return employees ?? Array.Empty<Employee>();
    }
}
