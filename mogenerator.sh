#!/bin/bash
cd HackerBooks
/usr/bin/mogenerator -v2 arc=true -m Model/Books.xcdatamodeld/Books2.xcdatamodel/ -M Model/Machine/ -H Model/Human/
