using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Components;
using UI.Services;

namespace UI.Pages
{
    public abstract class FlowbitePage: LayoutComponentBase
    {
        [Inject]
        public IFlowbiteService FlowbiteService { get; set; } = default!;

        protected override async Task OnAfterRenderAsync(bool firstRender)
        {
            if (firstRender)
            {
                await FlowbiteService.InitializeFlowbiteAsync();
            }

            await base.OnAfterRenderAsync(firstRender);
        }
    }
}