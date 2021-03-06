//+------------------------------------------------------------------+
//|                                                Morning Glory.mq4 |
//|                                                             Jens |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Jens"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int OnInit()
  {
//--- indicator buffers mapping
        
    ObjectCreate("Midrange", OBJ_LABEL, 0, 0, 0);
    ObjectSet("Midrange", OBJPROP_CORNER, 1);
    ObjectSet("Midrange", OBJPROP_XDISTANCE, 10);
    ObjectSet("Midrange", OBJPROP_YDISTANCE, 90);
    ObjectSetText("Midrange", "Midrange: " + DoubleToString(midrange,2), 10, "Arial", clrYellow);
    


//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
                            
                
  {
//---
    ObjectCreate("PD_LOW", OBJ_HLINE, 0, Time[0], PD_LOW, 0, 0);
    ObjectCreate("PD_HIGH", OBJ_HLINE, 0, Time[0], PD_HIGH, 0, 0);
    ObjectCreate("intraday range", OBJ_LABEL, 0, 0, 0);
    ObjectSet("intraday range", OBJPROP_CORNER, 1);
    ObjectSet("intraday range", OBJPROP_XDISTANCE, 10);
    ObjectSet("intraday range", OBJPROP_YDISTANCE, 115);
    ObjectSetText("intraday range", "intraday range: " + DoubleToString(ATR_levels("xATR","xATRUP"),4), 10, "Arial", clrYellow);
    
    ObjectCreate("top 0.7 ATR", OBJ_HLINE, 0, Time[0],  ATR_levels("xATR","xATRUP"),0 ,0);
    ObjectCreate("bottom 0.7 ATR", OBJ_HLINE, 0, Time[0], 0, ATR_levels("xATR","xATRDOWN"), 0);
    ObjectCreate("top 0.8 ATR", OBJ_HLINE, 0, Time[0], 0, ATR_levels("yATR","yATRUP"),  0);
    ObjectCreate("bottom 0.8 ATR", OBJ_HLINE, 0, Time[0], 0, ATR_levels("yATR","yATRDOWN"), 0);    
    
//--- return value of prev_calculated for next call
   return(rates_total);
  }
 



double PD_LOW = iLow(NULL,1440,1);
double PD_HIGH = iHigh(NULL,1440,1);
double xATR = iATR(NULL,1440,10,0) * 0.7;     // 0.7 ATR value
double yATR = iATR(NULL,1440,10,0) * 0.8;     // 0.8 ATR value
double midrange = (iClose(NULL,1440,1)-iLow(NULL,1440,1))/(iHigh(NULL,1440,1)-iLow(NULL,1440,1));



double TODAY_OPEN = iOpen(NULL,1440,0);
double TODAY_UP = TODAY_OPEN + MarketInfo(Symbol(), MODE_DIGITS);
double TODAY_DOWN = TODAY_OPEN - MarketInfo(Symbol(), MODE_DIGITS);

double ATR_levels(string ATR, string ATR_level) 
   {
   
   double xATRUP;    // top of the 0.7 ATR range
   double xATRDOWN;  // bottom of the 0.7 ATR range
   double yATRUP;    // top of the 0.8 ATR range
   double yATRDOWN;  // bottom of the 0.8 ATR range
   double Intraday_range = iHigh(NULL,1440,0)-iLow(NULL,1440,0);
   
   if (ATR == "xATR")
      {
      
           
         
         if (ATR_level == "xATRUP")
            {
            xATRUP = iLow(NULL,1440,0)+xATR;
            
            return xATRUP;
      
            }
         
         else if (ATR_level =="xATRDOWN")
            {
            xATRDOWN = iHigh(NULL,1440,0)-xATR;
            
            return xATRDOWN;
            }
        
 
      }
   else if (ATR == "yATR")
      {
     
         
         
         if (ATR_level == "yATRUP")
            {
            yATRUP = iLow(NULL,1440,0)+yATR;
            
            return yATRUP;
            }
            
         else if (ATR_level == "yATRDOWN")
            {
            
            yATRDOWN = iHigh(NULL,1440,0)-yATR;
            
            return yATRDOWN;
            
            }
         

      }
   }


int deinit()
   {
   
   ObjectDelete("PD_LOW");
   ObjectDelete("PD_HIGH");
   ObjectDelete(ATR_levels("xATR","xATRUP"));
   ObjectDelete("Midrange");
   ObjectDelete("intraday range");
   
   
   return(0);
   
   }
