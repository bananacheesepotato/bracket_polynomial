R.<A,y,z,t,a,b,c,x>=PolynomialRing(QQ,('A','y','z','t','a','b','c','x'))
#R.<A,y,z,t,a,b,c,x>=LaurentSeriesRing(QQ,('A','y','z','t','a','b','c','x'))

#this function converts the list of lists from GAP into a readable output expression for the final kauffman bracket polynomial
#a=x_1, b=y_1, c=z_1

def f(d):
    p=0
    q=0
    for i in d:
        q=0
        for j in i:
            if len(j)==1:
                q=j[1]
            elif len(j)==2:
                if j[1]==0:
                    q=q*x^j[2]
                elif j[1]==1:
                    q=q*y^j[2]
                elif j[1]==2:
                    q=q*z^j[2]
                elif j[1]==3:
                    q=q*t^j[2]
                elif j[1]==4:
                    q=q*a^j[2]
                elif j[1]==5:
                    q=q*b^j[2]
                elif j[1]==6:
                    q=q*c^j[2]
        p=p+q
    return latex(p)


print('finished')
