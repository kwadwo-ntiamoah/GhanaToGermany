using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.JSInterop;

namespace UI.Services
{
    public interface IFlowbiteService
    {
        ValueTask InitializeFlowbiteAsync();
    }

    public class FlowbiteService(IJSRuntime jsRuntime) : IFlowbiteService
    {
        private readonly IJSRuntime _jsRuntime = jsRuntime;

        public async ValueTask InitializeFlowbiteAsync()
    {
        await _jsRuntime.InvokeVoidAsync("flowbiteInterop.initializeFlowbite");
    }
    }
}