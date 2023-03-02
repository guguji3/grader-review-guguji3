CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission
echo 'In submission directory'

cp ListExamples.java ..
cd ..
GRADE=100

if [[ -f ListExamples.java ]]
then
    echo 'ListExamples found'
else
    echo 'Need File ListExamples.java'
    GRADE-=100
fi

FILTER=grep -c -i "static List<String> filter(List<String> list, StringChecker sc)" ListExamples.java
MERGE=grep -c -i "static List<String> merge(List<String> list1, List<String> list2)" ListExamples.java

if [[ $FILTER -eq 1 ]]
then
    echo "Filter method found."
else
    echo "Filter method not found."
    GRADE-=50
fi

if [[ $MERGE -eq 1 ]]
then
    echo "Merge method found."
else
    echo "Merge method not found."
    GRADE-=50
fi

javac -cp $CPATH.java
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > errorFile.txt 2>&1

if grep -q "OK" errorFile.txt
then
    echo "Great job!"
    echo "Grade: 100/100"
else
    FAILURES=grep -c "Failure" errorFile.txt
    FAILURES*=25
    GRADE-=FAILURES
    echo "Grade: "$GRADE"/100"
fi
