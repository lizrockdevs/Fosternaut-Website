function fosterFilter() {
  // Declare variables
  let input, filter, div, name, a, i, txtValue;
  input = document.getElementById("filter");
  filter = input.value.toUpperCase();
  div = document.getElementById("div");
  name = div.getElementsByTagName("name");

  // Loop through all fosters, and hide those who don't match the search query
  for (i = 0; i < name.length; i++) {
    a = name[i].getElementsByTagName("a")[0];
    txtValue = a.textContent || a.innerText;
    if (txtValue.toUpperCase().indexOf(filter) > -1) {
      name[i].style.display = "";
    } else {
      name[i].style.display = "none";
    }
  }
}

const button = document.getElementById("submit-contact");
button.addEventListener("click", () => {
  alert(
    "This is portfolio site, therefore this form goes nowhere. Hope your day is going well & thanks for visiting! :)"
  );
});
