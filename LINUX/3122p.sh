#!/bin/bash
grep "02:00:00 PM" 0312_Dealer_schedule > dealer
awk '{print $1, $2, $5, $6}' dealer >> dealer_losses
