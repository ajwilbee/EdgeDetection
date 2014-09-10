function rulesMaskCA = maskCA(rule_number, mask)
if rule_number>511
    rule_number=250;
end
maskCA = [mask(2,2) mask(2,3) mask(3,3) mask(3,2) mask(3,1) mask(2,1) mask(1,1) mask(1,2) mask(1,3)];
baz        = num2matrix(dec2bin(rule_number));

%works because the only rules being used can be xored together
baz = [zeros(1,9-length(baz)) baz ]; 
rulesMaskCA = flip(baz).*maskCA;
rulesMaskCA(rulesMaskCA==0)= [];




