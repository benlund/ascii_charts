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

## Install

    $ sudo gem install ascii_charts

## Summary

    require 'ascii_charts'

Display a simple graph

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

Display the same graph as an histogram

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

Draw a function (e^x)

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

Draw a normal distribution

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


Draw two series with custom markers

    xs1 = (1..10).to_a
    ys1 = (1..10).to_a
    ys2 = (1..10).to_a.map { |i| i*(1/2.0) }

    graph = AsciiCharts::Cartesian.new(
      [xs1, ys1, ys2],
      markers: ['👋', '👍']
    )

    10.0|                            👋
    9.5|
    9.0|                         👋
    8.5|
    8.0|                      👋
    7.5|
    7.0|                   👋
    6.5|
    6.0|                👋
    5.5|
    5.0|             👋              👍
    4.5|                         👍
    4.0|          👋           👍
    3.5|                   👍
    3.0|       👋        👍
    2.5|             👍
    2.0|    👋     👍
    1.5|       👍
    1.0| 👋  👍
    0.5| 👍
    0.0+------------------------------
    1  2  3  4  5  6  7  8  9 10


## Changelog

Please see the [CHANGELOG.md](https://github.com/paulRbr/ascii_charts/blob/master/CHANGELOG.md) file for details
