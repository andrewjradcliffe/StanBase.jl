using StanBase
using Test

stan_prog = "
data { 
  int<lower=1> N; 
  int<lower=0,upper=1> y[N];
  real empty[0];
} 
parameters {
  real<lower=0,upper=1> theta;
} 
model {
  theta ~ beta(1,1);
  y ~ bernoulli(theta);
}
";


@testset "Basic HelpModel" begin
  
  stanmodel = HelpModel( "help", stan_prog)
  println("Model compilation completed.")

  res = stan_sample(stanmodel; n_chains=1)

  if !isnothing(res[1])

    run(`cat $(res[1][2])`)
    
    @test stanmodel.method == StanBase.Help(:help)
    @test StanBase.get_n_chains(stanmodel) == 1

  end

end
