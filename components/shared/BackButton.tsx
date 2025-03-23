import Link from "next/link";
import { Button } from "../ui/button";

const BackButton = () => {
  return (
    <Button asChild variant="back" className="absolute left-10 top-10 mb-10">
      <Link href={"/"}>Back home</Link>
    </Button>
  );
};

export default BackButton;
