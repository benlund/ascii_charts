# ASCII Charts

A Ruby library for generating plain text x,y cartesian plots and histograms that can be displayed in a terminal session.

## Features

 * Very simple API, your data may already in the correct format to be plotted
 * Dynamically scales the y-axis
 * Simple configuration options, including chart title

## Unfeatures

 * Data must be pre-sorted 
 * x axis will not be continuous if your data isn't
 * Only x,y point graphs and bar histograms supported
 * Minimal configuration options

## Update in 0.9.2

 * Now supports a different way of passing the inputs
 * Supports more than one data series per chart   
   In the case of bar chart, the values will be stacked according to data sequence. 
 * Supports the selection of marker characters
   User can specify one marker, in which case all line sequences will use that marker. Or user can specify marker at least the same number as the number of data series. 
 * Now allows nil in the y-values, in which case the corresponding point will be left blank 

## Install

    $ sudo gem install ascii_charts

## Summary

    require 'ascii_charts'
    
    ## data must be a pre-sorted array of x,y pairs
    puts AsciiCharts::Cartesian.new([[0, 1], [1, 3], [2, 7], [3, 15], [4, 4]]).draw
    
    15|      *   
    14|          
    13|          
    12|          
    11|          
    10|          
     9|          
     8|          
     7|    *     
     6|          
     5|          
     4|        * 
     3|  *       
     2|          
     1|*         
     0+----------
       0 1 2 3 4 
    
    ## as a histogram
    puts AsciiCharts::Cartesian.new([[0, 1], [1, 3], [2, 7], [3, 15], [4, 4]], :bar => true, :hide_zero => true).draw
    
    15|      *   
    14|      *   
    13|      *   
    12|      *   
    11|      *   
    10|      *   
     9|      *   
     8|      *   
     7|    * *   
     6|    * *   
     5|    * *   
     4|    * * * 
     3|  * * * * 
     2|  * * * * 
     1|* * * * * 
     0+----------
       0 1 2 3 4 
    
    ## draw y = e^x for 0 <= x < 10
    puts AsciiCharts::Cartesian.new((0...10).to_a.map{|x| [x, Math::E ** x]}, :title => 'y = e^x').draw
    
              y = e^x          
     
    8500.0|                    
    8000.0|                  * 
    7500.0|                    
    7000.0|                    
    6500.0|                    
    6000.0|                    
    5500.0|                    
    5000.0|                    
    4500.0|                    
    4000.0|                    
    3500.0|                    
    3000.0|                *   
    2500.0|                    
    2000.0|                    
    1500.0|                    
    1000.0|              *     
     500.0|            *       
       0.0+*-*-*-*-*-*---------
           0 1 2 3 4 5 6 7 8 9 
    
    ## draw a normal distribution with a mean of 10 and a variance of 3 for 0 <= x < 20
    puts AsciiCharts::Cartesian.new((0...20).to_a.map{|x| [x, (1/Math.sqrt(2*Math::PI*3)) * (Math::E ** -(((x-10)**2)/(2*3)))]}, :title => 'Normal Distribution', :bar => true).draw
    
                           Normal Distribution                       
     
    0.24|                         *  *  *  *  *                      
    0.22|                         *  *  *  *  *                      
     0.2|                         *  *  *  *  *                      
    0.18|                         *  *  *  *  *                      
    0.16|                         *  *  *  *  *                      
    0.14|                         *  *  *  *  *                      
    0.13|                         *  *  *  *  *                      
    0.12|                         *  *  *  *  *                      
     0.1|                         *  *  *  *  *                      
    0.08|                      *  *  *  *  *  *  *                   
    0.06|                      *  *  *  *  *  *  *                   
    0.04|                   *  *  *  *  *  *  *  *  *                
    0.02|                   *  *  *  *  *  *  *  *  *                
     0.0+-*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*-
          0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 

    ## draw a line with multiple data series. Argument format is (x-array, y1-array... ym-array, options)
    puts AsciiCharts::Cartesian.new([0, 1, 2, 3], [10, 20, nil, 25], [5, 0, 5, 10], :markers => ['*','x']).draw

    26|      *
    24|
    22|
    20|  *
    18|
    16|
    14|
    12|
    10|*     x
     8|
     6|x   x
     4|
     2|
     0+--x-----
       0 1 2 3

    ## draw a bar chart for multiple series
    puts AsciiCharts::Cartesian.new([0, 1, 2], [1, 10, 4], [2, 0, 6], [2, 1, 6], :bar => true, :hide_zero => true, :markers => ['*','o','x']).draw

    16|    x
    15|    x
    14|    x
    13|    x
    12|    x
    11|  x x
    10|  * o
     9|  * o
     8|  * o
     7|  * o
     6|  * o
     5|x * o
     4|x * *
     3|o * *
     2|o * *
     1|* * *
     0+------
       0 1 2

    ## alternative way of insert multiple series. Argument format is ([[x1 with y's], ...[xn with y's]], options) 
    puts AsciiCharts::Cartesian.new([[0, 1, 2, 2], [1, 10, 0, 1], [2, 4, 6, 6]], :bar => true, :hide_zero => true, :markers => ['*','o','x']).draw
    16|    x
    15|    x
    14|    x
    13|    x
    12|    x
    11|  x x
    10|  * o
     9|  * o
     8|  * o
     7|  * o
     6|  * o
     5|x * o
     4|x * *
     3|o * *
     2|o * *
     1|* * *
     0+------
       0 1 2
