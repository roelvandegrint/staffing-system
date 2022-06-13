using Microsoft.AspNetCore.Mvc;
using frontend.Shared;
using Dapr.Client;

namespace frontend.Server.Controllers;

[ApiController]
[Route("[controller]")]
public class EmployeesController : ControllerBase
{
    private readonly ILogger<EmployeesController> _logger;
    private readonly DaprClient _daprClient;

    public EmployeesController(ILogger<EmployeesController> logger, DaprClient daprClient)
    {
        _logger = logger;
        _daprClient = daprClient;
    }

    [HttpGet]
    public async Task<IEnumerable<Employee>> Get()
    {
        // TODO: Get Employees Service Name from configuration
        var employees = await _daprClient.InvokeMethodAsync<IEnumerable<Employee>>(HttpMethod.Get, "employees-svc", "");
        return employees ?? Array.Empty<Employee>();
    }
}
