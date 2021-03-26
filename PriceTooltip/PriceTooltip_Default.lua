PriceTooltip.Default =
{
	Init				=
	{
		FirstTime_1	= true,
		FirstTime_2	= true,
		FirstTime_3	= true,
		FirstTime_4	= true,
		FirstTime_5 = true,
		FirstTime_6 = true
	},
	RoundPrice			= false,
	Separator			= "'",
	TooltipLineSpacing	= -5,
	Font				= "ZoFontWinH4",
	TooltipColor		=
	{
		Red		= 0.58,
		Green	= 1,
		Blue	= 0.54
	},
	PriceInfoFont		= "ZoFontGameSmall",
	TooltipPriceInfoColor =
	{
		Red		= 0.39,
		Green	= 0.59,
		Blue	= 0.78
	},
	
	--Context Menu
	UsePriceToChat		= true,
	PriceToChatColor	=
	{
		Red		= 1,
		Green	= 0.83,
		Blue	= 0
	},

	--Grid Sort
	UseGridSort				= true,
	UseGridCacheModus		= true,
	SortGridByStackValue	= false,
	GridSortBehaviour		= "Average price",

	DisplayVendorPrice	= true,
	UseProfitPrice		= false,
	DisplayProfitPrice	= false,
	ScaleProfitPrice	= 50,

	--TCC
	UseTTCPrice 		= false,
	ScaleTTCPrice		= 10,
	IncludeAvgTTCPrice	= true,
	ScaleAvgTTCPrice	= 0,
	AvgTTCPriceColor	=
	{
		Red		= 0,
		Green	= 1,
		Blue	= 1
	},
	DisplayTTCPrice		= false,
	DisplayTTCPriceInfo = false,

	--MM
	UseMMPrice			= false,
	DisplayMMPrice		= false,
	DisplayMMPriceInfo	= false,
	ScaleMMPrice 		= 0,

	--ATT
	UseATTPrice			= false,
	DisplayATTPrice		= false,
	ScaleATTPrice		= 0,
	ATTDays				= 10,

	--Average
	UseAveragePrice		= true,
	DisplayAveragePrice	= true,
	IncludeTTCInAP		= true,
	IncludeTTCAvgInAP	= true,
	IncludeMMInAP		= true,
	IncludeATTInAP		= true,

	--BestPrice
	UseBestPrice		= false,
	DisplayBestPrice	= false,
	IncludeTTCAvgInBP	= true,
	IncludePPInBP		= false,

	UseGridItemPriceOverride	= true,
	GridItemPriceOverrideBehaviour	= "Average price",
	ShowSingleItemPriceInGrid = false,
	UseMinItemGridPrice = false,
	MinItemGridPrice = 100,
	GridPriceColor		=
	{
		Red		= 0.58,
		Green	= 1,
		Blue	= 0.54
	},
	LowPriceIndicatorTooltip = true,
	LowPriceIndicatorGrid = true,
	VendorPriceLowPriceIndicatorColor =
	{
		Red		= 1,
		Green	= 0,
		Blue	= 0
	},
	ProfitPriceLowPriceIndicatorColor =
	{
		Red		= 1,
		Green	= 1,
		Blue	= 0
	},
	FixDoubleTooltip = false
}