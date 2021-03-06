@testset "Conjugacy classes in symmetric groups" begin
  n = 5
  G = symmetric_group(n)
  
  cc = conjugacy_class(G, G[1])
  cc1 = conjugacy_class(G, G[1]^G[2])
  @test order(cc) == order(cc1)
  @test cc == cc1
  
  ccid = conjugacy_class(G,one(G))
  @test order(ccid)==1
  @test elements(ccid) == [one(G)]
  
  x = perm(G,vcat(2:n,[1]))
  cc = conjugacy_class(G,x)
  @test order(cc) == factorial(n-1)
  @test x == representative(cc)
  y = rand(cc)
  @test order(y) == order(x)
  @test isconjugate(G,x,x^y)[1]
  z = isconjugate(G,x,x^y)[2]
  @test x^z == x^y
  z = cperm(G,[1,2])
  @test !isconjugate(G,x,z)[1]


# something in smaller dimension
  @test number_conjugacy_classes(symmetric_group(4)) == 5
  G = symmetric_group(4)
  x = perm(G,[3,4,1,2])
  cc = conjugacy_class(G,x)

  @test order(cc) == 3
  @test Set(elements(cc)) == Set([x^y for y in G])
  y = rand(cc)
  @test y in elements(cc)
  @test order(y) == 2

  C = conjugacy_classes(G)
  @test length(C) == 5
  @test cc in C
  @test sum([order(c) for c in C]) == order(G)
  @test sum([x in elements(c) for c in C]) == 1          # x belongs to a unique conjugacy class
  @test sum([y in elements(c) for c in C]) == 1          # x belongs to a unique conjugacy class
  z = rand(G)
  @test sum([z in elements(c) for c in C]) == 1          # x belongs to a unique conjugacy class
  @testset for i in 1:5
     c = C[i]
     x = rand(c)
     y = rand(c)
     @test isconjugate(G,x,y)[1]
     z = isconjugate(G,x,y)[2]
     @test x^z == y
     y = rand(C[(i%5)+1])
     @test !isconjugate(G,x,y)[1]
  end

  CC = conjugacy_classes_subgroups(G)
  @test length(CC)==11
  @testset for i in 1:length(CC)
     @test CC[i] == conjugacy_class(G,representative(CC[i]))
     @test order(CC[i]) == index(G, normalizer(G,representative(CC[i]))[1])
  end
  H=rand(subgroups(G))
  @test sum([order(c) for c in CC]) == length(subgroups(G))
  @test sum([H in elements(c) for c in CC]) == 1         # H belongs to a unique conjugacy class
  @testset for i in 1:length(CC)
     c = CC[i]
     x = rand(c)
     y = rand(c)
     @test isconjugate(G,x,y)[1]
     z = isconjugate(G,x,y)[2]
     @test x^z == y
     y = rand(CC[(i % length(CC))+1])
     @test !isconjugate(G,x,y)[1]
  end

  G = symmetric_group(10)
  x = rand(G)
  H = sub(G,[x])[1]
  z = rand(G)
  K = H^z
  @test Set(K) == Set([y^z for y in H])

end

function TestConjCentr(G,x)
   Cx = centralizer(G,x)[1]
   cc = conjugacy_class(G,x)
   @test index(G,Cx)==order(cc)
   T=right_transversal(G,Cx)
   @testset for y in elements(cc)
       @test sum([y==x^t for t in T])==1
   end
   
   cs = conjugacy_class(G,Cx)
   Nx = normalizer(G,Cx)[1]
   @test index(G,Nx)==order(cs)
   T=right_transversal(G,Nx)
   # Set([Cx^t for t in T]) == Set(elements(cs)) does not work
   @testset for H in elements(cs)
       @test sum([H==Cx^t for t in T])==1
   end
end

@testset "Conjugation and centralizers" begin
   G = symmetric_group(6)
   x = cperm(G,[1,2,3,4])
   TestConjCentr(G,x)

   G = GL(3,3)
   x = G[2]
   TestConjCentr(G,x)

   G = special_unitary_group(2,3)
   x = G[1]
   TestConjCentr(G,x)
end
