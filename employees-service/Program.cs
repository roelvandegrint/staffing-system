var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

var employees = new[]
{
    new Employee("Roel", "van de", "Grint", "16-01-1985"),
    new Employee("Arjan", null, "Nieuwenhuis", "May 27th"),
    new Employee("Martijn","de","Graaf", null),
    new Employee("Vincent",null,"Keizer", null)
};

app.MapGet("/", () => employees);

app.Run();

record Employee(string FirstName, string? prefix, string LastName, string? DateOfBirth) { }