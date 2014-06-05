Map {
  background-color: transparent;
}

#countries {
  ::outline {
    line-color: #85c5d3;
    line-width: 2;
    line-join: round;
  }
  polygon-fill: #fff;
}

#parcelsmap {
  line-color:#333;
  line-width:0.0;
  polygon-opacity:1;
  polygon-fill:#ae8;
  
  /*[Market_Value_15 >= 0] [Market_Value_15 < 100000] 
    { polygon-fill:#fff7fb; }
  [Market_Value_15 >= 100000] [Market_Value_15 < 150000] 
    { polygon-fill:#ece7f2; }
  [Market_Value_15 >= 150000] [Market_Value_15 < 250000] 
    { polygon-fill:#d0d1e6; }
  [Market_Value_15 >= 250000] [Market_Value_15 < 400000] 
    { polygon-fill:#a6bddb; }
  [Market_Value_15 >= 400000] [Market_Value_15 < 600000] 
    { polygon-fill:#74a9cf; }
  [Market_Value_15 >= 600000] [Market_Value_15 < 850000] 
    { polygon-fill:#3690c0; }
  [Market_Value_15 >= 850000] [Market_Value_15 < 1250000] 
    { polygon-fill:#0570b0; }
  [Market_Value_15 >= 1250000] [Market_Value_15 < 2250000] 
    { polygon-fill:#045a8d; }
  [Market_Value_15 >= 2250000]  
    { polygon-fill:#023858; }*/
  
  [tax_value_2015 = 0] { polygon-fill: maroon }
  [tax_value_2015 > 0] [tax_value_2015 < 50000] 
    { polygon-fill:#fff7fb; }
  [tax_value_2015 >= 50000] [tax_value_2015 < 100000] 
    { polygon-fill:#ece7f2; }
  [tax_value_2015 >= 100000] [tax_value_2015 < 200000] 
    { polygon-fill:#d0d1e6; }
  [tax_value_2015 >= 200000] [tax_value_2015 < 300000] 
    { polygon-fill:#a6bddb; }
  [tax_value_2015 >= 300000] [tax_value_2015 < 500000] 
    { polygon-fill:#74a9cf; }
  [tax_value_2015 >= 500000] [tax_value_2015 < 700000] 
    { polygon-fill:#3690c0; }
  [tax_value_2015 >= 700000] [tax_value_2015 < 1000000] 
    { polygon-fill:#0570b0; }
  [tax_value_2015 >= 1000000] [tax_value_2015 < 1500000] 
    { polygon-fill:#045a8d; }
  [tax_value_2015 >= 1500000]  
    { polygon-fill:#023858; }
   
}
