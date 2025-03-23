import Link from "next/link";
import { Button } from "../ui/button";

const BackButton = () => {
  return (
    <Button className="mb-10">
      <Link href={"/"}>Back home</Link>
    </Button>
  );
};

export default BackButton;
