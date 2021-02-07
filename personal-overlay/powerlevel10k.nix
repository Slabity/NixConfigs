{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "powerlevel10k";
  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k";
    rev = "master";
    sha256 = "08zg4in70h3kray6lazszzy26gvil9w2cr6xmkbgjsv3k6w3k0jg";
  };

  installPhase = ''
    mkdir -p $out/powerlevel10k
    mv * $out/powerlevel10k
  '';
}
