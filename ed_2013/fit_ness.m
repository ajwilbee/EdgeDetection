function [fposition, t_Img]=fit_ness(imgGrey,Img,parameters)

n=size(Img,1);
m=size(Img,2);
image=zeros(n,m);
MaskCA = getMaskCA(parameters(3,1));
    for i=1:n
        for j=1:m
            if (j+2<=m) && (i+2<=n)
                mask=imgGrey(i:i+2,j:j+2);
                rule_nbd=sum(sum(abs(MaskCA.*(mask-mask(2,2)))));
                %% Fuzzy CA
                mf = rule_nbd/(rule_nbd+parameters(1,1));
                if mf >parameters(2,1)
                    image(i+1,j+1)=1;
                else
                    image(i+1,j+1)=0;
                end
                

            end
        end
    end
        t_Img=image;
   fposition = BDM(t_Img,Img,'x', 2, 'euc');
end   
    

    