

// Only one trade is allowed everyday
// Check for any orders executed today
bool ChkTodayOrders()
{
    int orderDay;
    int today = DayOfYear();
    
    int currTtl = OrdersTotal();
    int hstTtl = OrdersHistoryTotal();
    
    // Check orders history
    for(int hstIx = hstTtl-1; hstIx >= 0; hstIx--)
    {
        OrderSelect(hstIx, SELECT_BY_POS, MODE_HISTORY);
        orderDay = TimeDayOfYear(OrderOpenTime());
        if(orderDay == today) return(true);
    }
    
    // Check current orders
    for(int currIx = currTtl-1; currIx >= 0; currIx--)
    {
        OrderSelect(currIx, SELECT_BY_POS);
        orderDay = TimeDayOfYear(OrderOpenTime());
        if(orderDay == today) return(true);
    }
    
    return(false);
}