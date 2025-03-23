import Link from "next/link";
import "@/app/globals.css";
import { Button } from "@/components/ui/button";
export default function Home() {
  return (
    <div>
      <div className="flex flex-col items-center gap-4 py-10">
        <Button asChild>
          <Link href="/tests/game">Random Game</Link>
        </Button>
        <Button asChild>
          <Link href="/tests/datatable">Data Table Demo</Link>
        </Button>
        <Button asChild>
          <Link href="/tests/layouts">Layouts</Link>
        </Button>
        <Button asChild>
          <Link href="/tests/timer">Timer</Link>
        </Button>
        <Button asChild>
          <Link href="/tests/meals">Meals</Link>
        </Button>
      </div>
    </div>
  );
}
