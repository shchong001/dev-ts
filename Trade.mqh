class CTrade
{
    private:
        static int magicNumber;
        enum CLOSE_MARKET_TYPE
        {
            CLOSE_BUY,
            CLOSE_SELL,
            CLOSE_ALL_MARKET
        };
        enum MODIFY_MARKET_TYPE
        {
            MOD_BUY,
            MOD_SELL,
            MOD_ALL_MARKET
        };
        
    public:
        static void SetMagicNumber(int pMagic);
        static int GetMagicNumber();
        void Buy(string pSymbol, double pVolume, double pStopLossPrice, double pTakeProfitPrice);
        void Sell(string pSymbol, double pVolume, double pStopLossPrice, double pTakeProfitPrice);
        void CloseMultipleOrders(CLOSE_MARKET_TYPE pCloseType);
        void ModifyOrders(MODIFY_MARKET_TYPE pModType, double pStopLossPrice);
        
};

int CTrade::magicNumber = 0;

static void CTrade::SetMagicNumber(int pMagic)
{
    magicNumber = pMagic;
}

static int CTrade::GetMagicNumber()
{
    return(magicNumber);
}

void CTrade::Buy(string pSymbol, double pVolume, double pStopLossPrice, double pTakeProfitPrice)
{
    double ask = MarketInfo(pSymbol, MODE_ASK);
    int ticket = OrderSend(pSymbol, OP_BUY, pVolume, ask, 0, pStopLossPrice, pTakeProfitPrice, NULL, magicNumber);
}

void CTrade::Sell(string pSymbol, double pVolume, double pStopLossPrice, double pTakeProfitPrice)
{
    double bid = MarketInfo(pSymbol, MODE_BID);
    int ticket = OrderSend(pSymbol, OP_SELL, pVolume, bid, 0, pStopLossPrice, pTakeProfitPrice, NULL, magicNumber);
}

void CTrade::CloseMultipleOrders(CLOSE_MARKET_TYPE pCloseType)
{
    for(int orderIndex = OrdersTotal()-1; orderIndex >= 0; orderIndex--)
    {
        bool isSelected = OrderSelect(orderIndex, SELECT_BY_POS);
        int orderType = OrderType();
        int orderMagic = OrderMagicNumber();
        int orderTicket = OrderTicket();
        double orderVol = OrderLots();
        
        if(magicNumber == orderMagic)
        {
            if((pCloseType == CLOSE_BUY && orderType == OP_BUY)
                || (pCloseType == CLOSE_SELL && orderType == OP_SELL)
                || ( pCloseType == CLOSE_ALL_MARKET && (orderType == OP_BUY || orderType == OP_SELL)))
            {
                double closePrice;
                if(orderType == OP_BUY) closePrice = MarketInfo(Symbol(), MODE_BID);
                else if(orderType == OP_SELL) closePrice = MarketInfo(Symbol(), MODE_ASK);
                OrderClose(orderTicket, orderVol, closePrice, 0);
            }
        }
    }
}

void CTrade::ModifyOrders(MODIFY_MARKET_TYPE pModType, double pStopLossPrice)
{
    for(int orderIndex = OrdersTotal()-1; orderIndex >= 0; orderIndex--)
    {
        bool isSelected = OrderSelect(orderIndex, SELECT_BY_POS);
        int orderType = OrderType();
        int orderMagic = OrderMagicNumber();
        int orderTicket = OrderTicket();
        
        if(magicNumber == orderMagic)
        {
            if((pModType == MOD_BUY && orderType == OP_BUY)
                || (pModType == MOD_SELL && orderType == OP_SELL))
            {
                OrderModify(orderTicket, OrderOpenPrice(), pStopLossPrice, OrderTakeProfit(), 0);
            }
        }
    }
}