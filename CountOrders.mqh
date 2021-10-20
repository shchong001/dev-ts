#include <Trade.mqh>

class CCount
{
    public:
        int Buy();
        int Sell();
        int BuyStop();
        int SellStop();
        int BuyLimit();
        int SellLimit();
        int TotalMarket();
        int TotalPending();
        int TotalOrders();
        
    private:
        enum COUNT_ORDER_TYPE
        {
            COUNT_BUY,
            COUNT_SELL,
            COUNT_BUY_STOP,
            COUNT_SELL_STOP,
            COUNT_BUY_LIMIT,
            COUNT_SELL_LIMIT,
            COUNT_MARKET,
            COUNT_PENDING,
            COUNT_ALL
        };
        
        int CountOrders(COUNT_ORDER_TYPE pType);
};

int CCount::Buy()
{
    return(CountOrders(COUNT_BUY));
}

int CCount::Sell()
{
    return(CountOrders(COUNT_SELL));
}

int CCount::BuyStop()
{
    return(CountOrders(COUNT_BUY_STOP));
}

int CCount::SellStop()
{
    return(CountOrders(COUNT_SELL_STOP));
}

int CCount::BuyLimit()
{
    return(CountOrders(COUNT_BUY_LIMIT));
}

int CCount::SellLimit()
{
    return(CountOrders(COUNT_SELL_LIMIT));
}

int CCount::TotalMarket()
{
    return(CountOrders(COUNT_MARKET));
}

int CCount::TotalPending()
{
    return(CountOrders(COUNT_PENDING));
}

int CCount::TotalOrders()
{
    return(CountOrders(COUNT_ALL));
}

int CCount::CountOrders(COUNT_ORDER_TYPE pType)
{
    int buy = 0, sell = 0, buyStop = 0, sellStop = 0, buyLimit = 0, sellLimit = 0, totalOrders = 0;
    
    for(int orderIndex = OrdersTotal()-1; orderIndex >= 0; orderIndex--)
    {
        bool isSelected = OrderSelect(orderIndex, SELECT_BY_POS);
        int orderType = OrderType();
        int orderMagic = OrderMagicNumber();
        
        // Call a static method in another class without creating a class object
        if(CTrade::GetMagicNumber() == orderMagic)
        {
            switch(orderType)
            {
                case OP_BUY:
                    buy++;
                    break;
                    
                case OP_SELL:
                    sell++;
                    break;
                    
                case OP_BUYSTOP:
                    buyStop++;
                    break;
                    
                case OP_SELLSTOP:
                    sellStop++;
                    break;
                    
                case OP_BUYLIMIT:
                    buyLimit++;
                    break;
                    
                case OP_SELLLIMIT:
                    sellLimit++;
                    break;
            }
            
            totalOrders++;
        }
    }
    
    int returnTotal = 0;
    switch(pType)
    {
        case COUNT_BUY:
            returnTotal = buy;
            break;
            
        case COUNT_SELL:
            returnTotal = sell;
            break;
            
        case COUNT_BUY_STOP:
            returnTotal = buyStop;
            break;
            
        case COUNT_SELL_STOP:
            returnTotal = sellStop;
            break;
            
        case COUNT_BUY_LIMIT:
            returnTotal = buyLimit;
            break;
            
        case COUNT_SELL_LIMIT:
            returnTotal = sellLimit;
            break;
            
        case COUNT_MARKET:
            returnTotal = buy + sell;
            break;
            
        case COUNT_PENDING:
            returnTotal = buyStop + sellStop + buyLimit + sellLimit;
            break;
            
        case COUNT_ALL:
            returnTotal = totalOrders;
            break;
    }
    
    return(returnTotal);
}