import '../Model/Animal.dart';

class GenerateAnimalList{
  List<Animal> animalsList = [
    Animal("ant", "assets/images/animals/ant.png"),
    Animal("bears", "assets/images/animals/bears.png"),
    Animal("cat", "assets/images/animals/cat.png"),
    Animal("cheetah", "assets/images/animals/cheetah.png"),
    Animal("crocodile", "assets/images/animals/crocodile.png"),
    Animal("dog", "assets/images/animals/dog.png"),
    Animal("elephant", "assets/images/animals/elephant.png"),
    Animal("fox", "assets/images/animals/fox.png"),
    Animal("gazelle", "assets/images/animals/gazelle.png"),
    Animal("hedgehog", "assets/images/animals/hedgehog.png"),
    Animal("lion", "assets/images/animals/lion.png"),
    Animal("lizard", "assets/images/animals/lizard.png"),
    Animal("owl", "assets/images/animals/owl.png"),
    Animal("panda", "assets/images/animals/panda.png"),
    Animal("parrot", "assets/images/animals/parrot.png"),
    Animal("pelican", "assets/images/animals/pelican.png"),
    Animal("pig", "assets/images/animals/pig.png"),
    Animal("rabbit", "assets/images/animals/rabbit.png"),
    Animal("raccoon", "assets/images/animals/raccoon.png"),
    Animal("squirrel", "assets/images/animals/squirrel.png"),
    Animal("tiger", "assets/images/animals/tiger.png"),
    Animal("turtle", "assets/images/animals/turtle.png"),
    Animal("zebra", "assets/images/animals/zebra.png"),
  ];

  List<Animal> getRandomAnimal(){
    List<Animal> result = [];
    List<Animal> animals = animalsList;
    for(int i=0;i<6;i++){
      var randomItem = (animals..shuffle()).first;
      result.add(randomItem);
      animals.remove(randomItem);
    }
    return result;
  }
}