## Step 3 — Apply the Fix

Add egress rules to allow UDP and TCP traffic on port 53 to the CoreDNS service IP range. Add an additional egress rule that permits connections to only the specific IP and port of the authorized upstream payment gateway. Test that DNS works again and that connections to unauthorized addresses remain blocked.
