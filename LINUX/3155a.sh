#!/bin/bash
grep "05:00:00 AM" 0315_Dealer_schedule > dealer
awk '{print $1, $2, $5, $6}' dealer >> dealer_losses
