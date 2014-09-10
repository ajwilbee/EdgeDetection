tic
rule_nbd=double(maskCA(parameters(3,1),mask));
               test = sum(abs(mask(2,2)-rule_nbd));
toc



tic
rule_nbd2=sum(sum(abs(MaskCA.*(mask-mask(2,2)))));
toc