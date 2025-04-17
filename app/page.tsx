import Link from "next/link";
import "@/app/globals.css";
import { Button } from "@/components/ui/button";
export default function Home() {
  return (
    <div className="flex flex-col justify-center items-center gap-4 py-10 h-screen">
      <Button variant="main" asChild>
        <Link href="/tests/game">Random Game</Link>
      </Button>
      <Button variant="main" asChild>
        <Link href="/tests/datatable">Data Table Demo</Link>
      </Button>
      <Button variant="main" asChild>
        <Link href="/tests/layouts">Layouts</Link>
      </Button>
      <Button variant="main" asChild>
        <Link href="/tests/timer">Timer</Link>
      </Button>
      <Button variant="main" asChild>
        <Link href="/tests/meals">Meals</Link>
      </Button>
      <Button variant="main" asChild>
        <Link href="/tests/deployment">Deployment</Link>
      </Button>
      <Button variant="main" asChild>
        <Link href="/tests/accordion">Accordion</Link>
      </Button>
    </div>
  );
}
